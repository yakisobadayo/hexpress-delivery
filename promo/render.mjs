// Capture every frame of index.html with Playwright, encode with ffmpeg, and mix the game's music + SFX.
// Usage: node render.mjs [--fps 60] [--workers 4] [--out out/hexpress-promo.mp4]
import { chromium } from 'playwright';
import { spawn } from 'node:child_process';
import path from 'node:path';
import fs from 'node:fs';

const arg = (k, d) => { const i = process.argv.indexOf(k); return i > 0 ? process.argv[i + 1] : d; };
const FPS = +arg('--fps', 60);
const WORKERS = +arg('--workers', 4);
const here = path.dirname(new URL(import.meta.url).pathname);
const OUT = path.resolve(here, arg('--out', 'out/hexpress-promo.mp4'));
const TMP = path.join(here, 'out', 'tmp');
const SOUNDS = path.resolve(here, '..', 'sounds');
fs.mkdirSync(TMP, { recursive: true });

const run = (cmd, args, opts = {}) => new Promise((res, rej) => {
  const p = spawn(cmd, args, { stdio: ['pipe', 'inherit', 'inherit'], ...opts });
  p.on('exit', (c) => (c === 0 ? res() : rej(new Error(`${cmd} exited ${c}`))));
  if (opts.feed) opts.feed(p);
});

const browser = await chromium.launch();
const url = 'file://' + path.join(here, 'index.html');
const probe = await browser.newPage();
await probe.goto(url);
await probe.waitForFunction(() => window.READY === true);
const { duration, sfx } = await probe.evaluate(() => ({ duration: window.DURATION, sfx: window.SFX }));
await probe.close();
const total = Math.round(duration * FPS);
console.log(`Rendering ${total} frames at ${FPS}fps with ${WORKERS} workers`);

// Each worker renders a contiguous chunk straight into its own ffmpeg segment (no PNGs on disk).
const chunk = Math.ceil(total / WORKERS);
let done = 0;
const segs = [];
await Promise.all(Array.from({ length: WORKERS }, async (_, w) => {
  const a = w * chunk, b = Math.min(total, a + chunk);
  const seg = path.join(TMP, `seg${w}.mp4`);
  segs[w] = seg;
  const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
  page.on('pageerror', (e) => console.error('[pageerror]', e.message));
  await page.goto(url);
  await page.waitForFunction(() => window.READY === true);
  const ff = spawn('ffmpeg', ['-y', '-v', 'error', '-f', 'image2pipe', '-framerate', String(FPS), '-c:v', 'png', '-i', '-',
    '-c:v', 'libx264', '-preset', 'slow', '-crf', '12', '-pix_fmt', 'yuv420p', seg], { stdio: ['pipe', 'inherit', 'inherit'] });
  const finished = new Promise((res, rej) => ff.on('exit', (c) => (c === 0 ? res() : rej(new Error('ffmpeg ' + c)))));
  for (let f = a; f < b; f++) {
    await page.evaluate((t) => window.renderAt(t), f / FPS);
    const buf = await page.screenshot({ type: 'png' });
    if (!ff.stdin.write(buf)) await new Promise((r) => ff.stdin.once('drain', r));
    if (++done % 120 === 0) console.log(`  ${done}/${total}`);
  }
  ff.stdin.end();
  await finished;
  await page.close();
}));
await browser.close();

// Concatenate segments.
const list = path.join(TMP, 'segs.txt');
fs.writeFileSync(list, segs.map((s) => `file '${s}'`).join('\n'));
const video = path.join(TMP, 'video.mp4');
await run('ffmpeg', ['-y', '-v', 'error', '-f', 'concat', '-safe', '0', '-i', list, '-c', 'copy', video]);

// Audio: route music + every SFX cue, delayed to its timestamp.
const soundFile = (name) => {
  const dir = path.join(SOUNDS, name);
  return path.join(dir, fs.readdirSync(dir).find((f) => /\.(wav|mp3|ogg)$/.test(f)));
};
const inputs = ['-i', soundFile('mus_route_3_loop_real')];
const filters = ['[0:a]volume=0.8,aformat=sample_rates=48000:channel_layouts=stereo[m]'];
sfx.forEach(([t, name, gain], i) => {
  inputs.push('-i', soundFile(name));
  const ms = Math.round(t * 1000);
  filters.push(`[${i + 1}:a]aformat=sample_rates=48000:channel_layouts=stereo,volume=${gain},adelay=${ms}|${ms}[s${i}]`);
});
const mixIns = '[m]' + sfx.map((_, i) => `[s${i}]`).join('');
filters.push(`${mixIns}amix=inputs=${sfx.length + 1}:normalize=0:dropout_transition=0,atrim=0:${duration},afade=t=out:st=${duration - 0.6}:d=0.6,alimiter=limit=0.95[a]`);
const audio = path.join(TMP, 'audio.wav');
await run('ffmpeg', ['-y', '-v', 'error', ...inputs, '-filter_complex', filters.join(';'), '-map', '[a]', audio]);

// Final delivery encode.
fs.mkdirSync(path.dirname(OUT), { recursive: true });
await run('ffmpeg', ['-y', '-v', 'error', '-i', video, '-i', audio, '-c:v', 'libx264', '-preset', 'slow', '-crf', '18',
  '-pix_fmt', 'yuv420p', '-profile:v', 'high', '-movflags', '+faststart', '-c:a', 'aac', '-b:a', '192k', '-shortest', OUT]);
console.log('Wrote', OUT);
