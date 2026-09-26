{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  # Minimal Apple SMC client (./smc-tool.c, ported from Linux's
  # drivers/hwmon/applesmc.c). Needed because the in-tree applesmc driver
  # exposes no generic key-write path, and we must arm the AUPO key.
  smc-tool = pkgs.stdenv.mkDerivation {
    pname = "smc-tool";
    version = "1";
    src = ./smc-tool.c;
    dontUnpack = true;
    buildPhase = ''
      cc -O2 -o smc-tool "$src"
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp smc-tool $out/bin/
    '';
  };
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/services/t3-server.nix
  ];

  home-manager.users.kk-spartans = {
    imports = [
      inputs.nix-packages.homeManagerModules.wacli-sync
      inputs.discord-cli.homeManagerModules.default
    ];

    services.wacli-sync.enable = true;
    services.discord-cli-follow = {
      enable = true;
      downloadMedia = true;
      environmentFile = "%h/.local/share/discord-cli/env";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.etc = {
    "asound.conf".text = ''
      pcm.!default {
        type plug
        slave.pcm "hw:0,0"
      }
      ctl.!default {
        type hw
        card 0
      }
    '';
    "alsa/alsa.conf".source = "${pkgs.alsa-lib}/share/alsa/alsa.conf";
  };

  environment.sessionVariables.ALSA_CONFIG_DIR = "/etc/alsa";
  environment.sessionVariables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  services.hardware.bolt.enable = true;

  boot.blacklistedKernelModules = [ "apple_gmux" ];

  # This host is an inference appliance. Keep the Ivy Bridge cores and both
  # Pitcairn cards out of their latency-oriented power-saving modes.
  systemd.services.local-inference-performance = {
    description = "Set persistent CPU/GPU inference performance policy";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ ! -w "$governor" ] || echo performance > "$governor"
      done
      for level in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        [ ! -w "$level" ] || echo high > "$level"
      done
    '';
  };

  # systemd.services.obsidian-bisync = {
  #   description = "Bisync Obsidian vault to remote";
  #   after = [ "network-online.target" ];
  #   wants = [ "network-online.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "kk-spartans";
  #     WorkingDirectory = "/home/kk-spartans/things/vault";
  #     ExecStart = "${pkgs.rclone}/bin/rclone bisync . obsidian:vault";
  #   };
  # };

  systemd.timers.obsidian-bisync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
    };
  };

  users.users.kk-spartans.extraGroups = [ "audio" ];

  environment.systemPackages = [
    pkgs.libva-utils
    pkgs.vulkan-tools
    pkgs.efibootmgr
    pkgs.efivar
    pkgs.pciutils
  ];

  # Headless boot on MacPro6,1: skip the systemd-boot menu entirely.
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.editor = false;

  # The Apple Startup Manager picker on every boot was forced by NVRAM
  # manufacturing-enter-picker=true (plus stale entries: Boot0001/Boot0002
  # with zero GUIDs, Boot0000 pointing at a pre-disko PARTUUID,
  # efi-boot-device blessed to a dead macOS installer). The systemd-boot
  # installer (canTouchEfiVariables, see modules/boot.nix) recreates the
  # valid entry on rebuild; this service deletes the stale ones, puts the
  # valid "Linux Boot Manager" entry first, and clears Apple's stale
  # blessed device + forced-picker flag so the firmware auto-boots.
  systemd.services.mac-pro-efi-boot-fix = {
    description = "Fix stale Apple/UEFI NVRAM boot entries on MacPro6,1";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -u
      EFIBOOTMGR=${pkgs.efibootmgr}/bin/efibootmgr
      BOOTCTL=${pkgs.systemd}/bin/bootctl
      BLKID=${pkgs.util-linux}/bin/blkid
      FINDMNT=${pkgs.util-linux}/bin/findmnt
      ESP_UUID=$($BLKID -s PARTUUID -o value "$($FINDMNT -no SOURCE /boot)" 2>/dev/null | tr '[:upper:]' '[:lower:]') || true
      entry_guid() {
        $EFIBOOTMGR -v 2>/dev/null | grep -E "^Boot$1[* ]" | grep -oiE 'GPT,[0-9a-f-]{36}' | head -n 1 | cut -d, -f2 | tr '[:upper:]' '[:lower:]' || true
      }
      is_linux_entry() {
        $EFIBOOTMGR -v 2>/dev/null | grep -E "^Boot$1[* ]" | grep -qi 'linux boot manager'
      }
      # Delete a Linux entry only if it is stale: missing GUID, zero GUID,
      # or pointing at a different ESP. Never touches valid entries
      # (e.g. the fallback entry bootctl manages) or Apple entries.
      delete_if_stale() {
        G=$(entry_guid "$1")
        if [ -z "''${G:-}" ] || [ "$G" = "00000000-0000-0000-0000-000000000000" ] || [ "$G" != "''${ESP_UUID:-$G}" ]; then
          if is_linux_entry "$1"; then
            $EFIBOOTMGR -B -b "$1" >/dev/null 2>&1 || true
          fi
        fi
      };
      delete_if_stale 0001
      delete_if_stale 0002
      ENTRY=$($EFIBOOTMGR -v 2>/dev/null | grep -i 'linux boot manager' | head -n 1 | grep -oE 'Boot[0-9A-Fa-f]{4}' | head -n 1 | sed 's/^Boot//') || true
      if [ -n "''${ENTRY:-}" ] && [ -n "''${ESP_UUID:-}" ]; then
        ENTRY_UUID=$($EFIBOOTMGR -v 2>/dev/null | grep -E "^Boot''${ENTRY}\*" | grep -oiE 'GPT,[0-9a-f-]{36}' | head -n 1 | cut -d, -f2 | tr '[:upper:]' '[:lower:]') || true
        if [ "''${ENTRY_UUID:-}" != "$ESP_UUID" ]; then
          $EFIBOOTMGR -B -b "$ENTRY" >/dev/null 2>&1 || true
          $BOOTCTL install --esp-path=/boot >/dev/null 2>&1 || true
          ENTRY=$($EFIBOOTMGR -v 2>/dev/null | grep -i 'linux boot manager' | head -n 1 | grep -oE 'Boot[0-9A-Fa-f]{4}' | head -n 1 | sed 's/^Boot//') || true
        fi
      fi
      # Put the valid entry first.
      if [ -n "''${ENTRY:-}" ]; then
        $EFIBOOTMGR -o "$ENTRY" >/dev/null 2>&1 || true
      fi
      # Clear Apple's stale blessed boot device (dead macOS installer) and the
      # forced-picker flag so the firmware auto-boots instead of showing the
      # Startup Manager.
      for VAR in efi-boot-device-7c436110-ab2a-4bbb-a880-fe41995c9f82 efi-boot-device-data-7c436110-ab2a-4bbb-a880-fe41995c9f82 manufacturing-enter-picker-7c436110-ab2a-4bbb-a880-fe41995c9f82; do
        F="/sys/firmware/efi/efivars/$VAR"
        if [ -e "$F" ]; then
          ${pkgs.e2fsprogs}/bin/chattr -i "$F" >/dev/null 2>&1 || true
          rm -f "$F" >/dev/null 2>&1 || true
        fi
      done
    '';
  };

  # Power on automatically after AC power loss. Two layers:
  # 1. PCH AFTERG3 bit (GEN_PMCON_3, LPC 00:1f.0 config byte 0xA4 bit 0).
  #    Reads 0 (boot) already; enforce it in case firmware ever flips it.
  # 2. SMC AUPO key (Auto Power-On): the SMC decides whether to bring the
  #    rails up when AC returns, and it defaults to staying off (0). macOS
  #    arms it on every boot via pmset autorestart; without macOS nothing
  #    arms it, so do it here. Re-armed every boot in case it is one-shot.
  systemd.services.mac-pro-power-restore = {
    description = "Ensure MacPro6,1 boots after AC power loss";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -u
      SETPCI=${pkgs.pciutils}/bin/setpci
      CUR=$($SETPCI -s 00:1f.0 0xa4.b 2>/dev/null) || CUR=""
      case "''${CUR:-}" in
        [0-9a-fA-F][0-9a-fA-F])
          if [ $((16#$CUR & 1)) -ne 0 ]; then
            $SETPCI -s 00:1f.0 0xa4.b=$(printf '%02x' $((16#$CUR & ~1)))
          fi
          ;;
      esac
      # The hwmon driver has no SMC key-write path, so talk to the SMC
      # directly; unbind the driver first to avoid port races, rebind after.
      SMC_TOOL=${smc-tool}/bin/smc-tool
      DRV=/sys/bus/platform/drivers/applesmc
      echo "applesmc.768" > "$DRV/unbind" 2>/dev/null || true
      $SMC_TOOL write AUPO 01 2>/dev/null || echo "smc-tool: AUPO write failed"
      VAL=$($SMC_TOOL read AUPO 1 2>/dev/null) || VAL=""
      echo "smc-tool: AUPO=$VAL"
      echo "applesmc.768" > "$DRV/bind" 2>/dev/null || true
    '';
  };
}
