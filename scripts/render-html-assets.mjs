import { createRequire } from "node:module";
import { fileURLToPath, pathToFileURL } from "node:url";
import path from "node:path";

const require = createRequire(import.meta.url);
const { chromium } = require("playwright");

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");

const specs = [
  {
    html: "Resources/promo_poster_review.html",
    selector: ".poster",
    output: "Resources/promo_poster.png",
    viewport: { width: 2200, height: 1280 }
  },
  {
    html: "Resources/quick_start_review.html",
    selector: ".sheet",
    output: "Resources/quick_start.png",
    viewport: { width: 1680, height: 1100 }
  },
  {
    html: "Resources/architecture_review.html",
    selector: ".canvas",
    output: "Resources/architecture_diagram.png",
    viewport: { width: 2200, height: 1280 }
  }
];

async function waitForAssets(page) {
  await page.waitForLoadState("load");
  await page.evaluate(async () => {
    if (document.fonts?.ready) {
      await document.fonts.ready;
    }

    await Promise.all(
      Array.from(document.images).map((image) => image.decode().catch(() => undefined))
    );
  });
}

const launchOptions = { headless: true };
if (process.env.CHROME_PATH) {
  launchOptions.executablePath = process.env.CHROME_PATH;
}

const browser = await chromium.launch(launchOptions);

try {
  for (const spec of specs) {
    const page = await browser.newPage({
      viewport: spec.viewport,
      deviceScaleFactor: 2
    });

    const htmlPath = path.join(rootDir, spec.html);
    const outputPath = path.join(rootDir, spec.output);

    await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "load" });
    await waitForAssets(page);
    await page.locator(spec.selector).screenshot({ path: outputPath });
    await page.close();

    console.log(`Rendered ${spec.output}`);
  }
} finally {
  await browser.close();
}
