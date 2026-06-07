import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { renderFire } from './fire';
import { loadBull, renderBull } from './bull';
import { loadFrame, renderFrame } from './frame';
import { loadText, renderText } from './text';
import { composite } from './render';

const FIRE_WIDTH = 42;
const FIRE_HEIGHT = 22;
const PAD_TOP = 1;
const PAD_LEFT = 6;

export default function (pi: ExtensionAPI) {
  let frame = 0;
  
  pi.on("session_start", async (_event, ctx) => {
    const bullLines = await loadBull();
    const frameLines = await loadFrame();
    const textLines = await loadText();
    
    if (ctx.mode !== "tui") return;
    
    ctx.ui.setHeader((tui, _theme) => {
      const intervalId = setInterval(() => {
        frame++;
        tui.requestRender();
      }, 200);

      return {
        render(_width: number) {
          const firePixels = renderFire(frame);
          const bullPixels = renderBull(bullLines, frame);
          const framePixels = renderFrame(frameLines);
          const textPixels = renderText(textLines);
          
          return composite([
            { pixels: firePixels, x: PAD_LEFT, y: PAD_TOP + 1 },
            { pixels: framePixels, x: 0, y: 1 },
            { pixels: textPixels, x: 0, y: 0 },
            { pixels: bullPixels, x: 0, y: 1 }
          ]);
        },
        invalidate() {
          clearInterval(intervalId);
          frame = 0;
        }
      };
    });
  });
}
