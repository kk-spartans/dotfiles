// smc-tool: minimal Apple SMC client for Intel Macs (Linux).
//
// Speaks the SMC PMIO protocol on ports 0x300/0x300 directly, ported from
// Linux's drivers/hwmon/applesmc.c. Used on MacPro6,1 to arm the AUPO
// (Auto Power-On) key, which the in-tree applesmc driver cannot write
// (it exposes no generic key-write sysfs node).
//
// Usage: smc-tool read KEY LEN | smc-tool write KEY HEX..
// Must run as root. Unbind the applesmc driver first to avoid port races:
//   echo applesmc.768 > /sys/bus/platform/drivers/applesmc/unbind
// ... then rebind afterwards.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/io.h>

#define DATA_PORT 0x300
#define CMD_PORT 0x304
#define ST_AWAITING 0x01
#define ST_IBCLOSED 0x02
#define ST_BUSY 0x04
#define READ_CMD 0x10
#define WRITE_CMD 0x11

static int wait_status(unsigned char val, unsigned char mask) {
  int us = 8, i;
  for (i = 0; i < 24; i++) {
    unsigned char st = inb(CMD_PORT);
    if ((st & mask) == val)
      return 0;
    usleep(us);
    if (i > 9)
      us <<= 1;
  }
  return -1;
}

static int send_byte(unsigned char b, unsigned short port) {
  if (wait_status(0, ST_IBCLOSED))
    return -1;
  /* separate read looking for BUSY after IB_CLOSED falls, like the driver */
  if (wait_status(ST_BUSY, ST_BUSY))
    return -1;
  outb(b, port);
  return 0;
}

static int send_command(unsigned char cmd) {
  if (wait_status(0, ST_IBCLOSED))
    return -1;
  outb(cmd, CMD_PORT);
  return 0;
}

static int smc_sane(void) {
  if (!wait_status(0, ST_BUSY))
    return 0;
  if (send_command(READ_CMD))
    return -1;
  return wait_status(0, ST_BUSY);
}

static int smc_read(const char *key, unsigned char *buf, int len) {
  int i;
  if (smc_sane())
    return -1;
  if (send_command(READ_CMD))
    return -1;
  for (i = 0; i < 4; i++)
    if (send_byte((unsigned char)key[i], DATA_PORT))
      return -1;
  if (send_byte((unsigned char)len, DATA_PORT))
    return -1;
  for (i = 0; i < len; i++) {
    if (wait_status(ST_AWAITING | ST_BUSY, ST_AWAITING | ST_BUSY))
      return -1;
    buf[i] = inb(DATA_PORT);
  }
  for (i = 0; i < 16; i++) {
    usleep(8);
    if (!(inb(CMD_PORT) & ST_AWAITING))
      break;
    (void)inb(DATA_PORT);
  }
  return wait_status(0, ST_BUSY);
}

static int smc_write(const char *key, const unsigned char *buf, int len) {
  int i;
  if (smc_sane())
    return -1;
  if (send_command(WRITE_CMD))
    return -1;
  for (i = 0; i < 4; i++)
    if (send_byte((unsigned char)key[i], DATA_PORT))
      return -1;
  if (send_byte((unsigned char)len, DATA_PORT))
    return -1;
  for (i = 0; i < len; i++)
    if (send_byte(buf[i], DATA_PORT))
      return -1;
  return wait_status(0, ST_BUSY);
}

int main(int argc, char **argv) {
  if (iopl(3)) {
    perror("iopl");
    return 1;
  }
  if (argc < 4 || strlen(argv[2]) != 4) {
    fprintf(stderr, "usage: %s read KEY LEN | %s write KEY HEX..\n", argv[0],
            argv[0]);
    return 2;
  }
  const char *key = argv[2];
  if (!strcmp(argv[1], "read")) {
    int len = atoi(argv[3]), i;
    unsigned char buf[32];
    if (len <= 0 || len > 32) {
      fprintf(stderr, "LEN must be 1..32\n");
      return 2;
    }
    if (smc_read(key, buf, len)) {
      fprintf(stderr, "read failed\n");
      return 1;
    }
    for (i = 0; i < len; i++)
      printf("%02x%s", buf[i], i + 1 < len ? " " : "\n");
    return 0;
  }
  if (!strcmp(argv[1], "write")) {
    unsigned char buf[32];
    int len = argc - 3, i;
    if (len < 1 || len > 32) {
      fprintf(stderr, "give 1..32 hex bytes\n");
      return 2;
    }
    for (i = 0; i < len; i++)
      buf[i] = (unsigned char)strtoul(argv[3 + i], NULL, 16);
    if (smc_write(key, buf, len)) {
      fprintf(stderr, "write failed\n");
      return 1;
    }
    printf("ok\n");
    return 0;
  }
  fprintf(stderr, "unknown subcommand\n");
  return 2;
}
