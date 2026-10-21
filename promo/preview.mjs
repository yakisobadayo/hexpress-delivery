// Render a handful of still frames for review: node preview.mjs out_dir t1 t2 ...
import { chromium } from 'playwright';
import path from 'node:path';
import fs from 'node:fs';

const [outDir, ...times] = process.argv.slice(2);
fs.mkdirSync(outDir, { recursive: true });
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
page.on('console', (m) => console.log('[page]', m.text()));
page.on('pageerror', (e) => console.log('[pageerror]', e.message));
await page.goto('file://' + path.resolve(path.dirname(new URL(import.meta.url).pathname), 'index.html'));
await page.waitForFunction(() => window.READY === true);
for (const t of times) {
  await page.evaluate((t) => window.renderAt(t), parseFloat(t));
  await page.screenshot({ path: path.join(outDir, `t${String(t).padStart(5, '0')}.png`) });
}
await browser.close();
