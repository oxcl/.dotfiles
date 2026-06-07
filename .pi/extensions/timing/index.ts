import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let startTime: number | null = null;
  let lastElapsed: string | null = null;

  pi.on("agent_start", async (_event, ctx) => {
    startTime = Date.now();
  });

  pi.on("agent_end", async (_event, ctx) => {
    if (startTime === null) return;
    lastElapsed = ((Date.now() - startTime) / 1000).toFixed(1);
    startTime = null;
    ctx.ui.setStatus("timing", `${lastElapsed}s`);
  });
}