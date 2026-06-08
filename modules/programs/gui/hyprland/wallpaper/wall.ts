import { spawn, execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { access, copyFile, mkdir, unlink, writeFile } from "node:fs/promises";
import { createInterface } from "node:readline";

const IMG_SIZE = 640;
const ROUNDNESS = 30;
const CANVAS_W = 1920;
const CANVAS_H = 1080;
const DARKEN_FACTOR = 0.75;
const BRIGHTNESS_THRESHOLD = 0.23;
const CACHE = "/tmp/wall-cache";

const hash = (url: string) => createHash("md5").update(url).digest("hex");

async function cached(url: string, suffix: string) {
  const p = `${CACHE}/${hash(url)}_${suffix}`;
  try { await access(p); return p; } catch { return null; }
}

function convert(...args: string[]): void {
  execFileSync("magick", args, { stdio: "inherit" });
}

function convertOut(...args: string[]): string {
  return execFileSync("magick", args, { stdio: "pipe" }).toString().trim();
}

function convertIn(input: Buffer, ...args: string[]): Buffer {
  const proc = spawn("magick", args, { stdio: ["pipe", "pipe", "inherit"] });
  const chunks: Buffer[] = [];
  proc.stdout!.on("data", (d: Buffer) => chunks.push(d));
  return new Promise((resolve, reject) => {
    proc.on("error", reject);
    proc.on("exit", (code) => {
      if (code === 0) resolve(Buffer.concat(chunks));
      else reject(new Error(`convert exited with ${code}`));
    });
    proc.stdin!.end(input);
  });
}

async function setWallpaper(path: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const proc = spawn("awww", ["img", path, "--transition-type", "any"], {
      stdio: "inherit",
    });
    proc.on("error", reject);
    proc.on("exit", (code) => {
      if (code === 0) resolve();
      else reject(new Error(`awww exited with ${code}`));
    });
  });
}

async function processUrl(url: string) {
  const cachedPath = await cached(url, "wall.png");
  if (cachedPath) {
    await copyFile(cachedPath, "/tmp/wall.png");
    await setWallpaper("/tmp/wall.png");
    return;
  }

  const resp = await fetch(url);
  const buf = Buffer.from(await resp.arrayBuffer());

  const t = `${CACHE}/${hash(url)}`;
  await mkdir(t, { recursive: true });

  const inputPath = `${t}/input`;
  const resizedPath = `${t}/resized.png`;
  const roundedPath = `${t}/rounded.png`;
  const outputPath = `${t}/output.png`;

  await writeFile(inputPath, buf);

  // Resize to IMG_SIZE
  convert(inputPath, "-resize", `${IMG_SIZE}x${IMG_SIZE}>`, resizedPath);

  // Get mean brightness (0.0 - 1.0)
  const mean = parseFloat(convertOut(resizedPath, "-colorspace", "Gray", "-format", "%[fx:mean]", "info:"));

  const darkPath = `${t}/darkened.png`;
  if (mean < BRIGHTNESS_THRESHOLD) {
    convert(resizedPath, "-modulate", `${Math.round(DARKEN_FACTOR * 100)}`, darkPath);
  } else {
    convert(resizedPath, "-modulate", "100", darkPath);
  }

  // Round corners
  convert(darkPath,
    "(", "+clone", "-alpha", "extract",
      "-draw", `roundrectangle 0,0,${IMG_SIZE},${IMG_SIZE},${ROUNDNESS},${ROUNDNESS}`,
    ")",
    "-alpha", "off", "-compose", "CopyOpacity", "-composite",
    roundedPath);

  // Composite onto black canvas
  convert("-size", `${CANVAS_W}x${CANVAS_H}`, "xc:black",
    roundedPath, "-gravity", "center", "-composite", outputPath);

  await copyFile(outputPath, "/tmp/wall.png");
  await writeFile(`${CACHE}/${hash(url)}_wall.png`, await Bun.file(outputPath).arrayBuffer());
  await setWallpaper("/tmp/wall.png");

  // Cleanup temp files
  for (const f of [inputPath, resizedPath, darkPath, roundedPath, outputPath]) {
    unlink(f).catch(() => {});
  }
  unlink(t).catch(() => {});
}

async function main() {
  await mkdir(CACHE, { recursive: true });

  // Initial blank wallpaper
  convert("-size", `${CANVAS_W}x${CANVAS_H}`, "xc:black", "/tmp/wall.png");
  await setWallpaper("/tmp/wall.png");

  const playerctl = spawn("playerctl", [
    "--follow", "metadata", "mpris:artUrl", "-p", "spotify",
  ], { stdio: ["ignore", "pipe", "inherit"] });

  const rl = createInterface({ input: playerctl.stdout });

  for await (const line of rl) {
    const url = line.trim();
    if (!url) continue;
    try {
      await processUrl(url);
    } catch (e) {
      console.error("wall: failed for", url, e);
    }
  }
}

main().catch(console.error);
