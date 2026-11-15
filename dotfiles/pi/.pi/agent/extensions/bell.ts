import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("agent_settled", (event, ctx) => {
    if (ctx.mode === "tui" && !event.aborted) process.stdout.write("\x07");
  });

  pi.on("ui_prompt_start", (_event, ctx) => {
    if (ctx.mode === "tui") process.stdout.write("\x07");
  });
}
