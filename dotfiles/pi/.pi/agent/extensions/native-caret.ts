import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { CURSOR_MARKER } from "@earendil-works/pi-tui";

const CSI_ESCAPE = /\x1b\[[0-?]*[ -/]*[@-~]/y;
const OSC_ESCAPE = /\x1b\][\s\S]*?(?:\x07|\x1b\\)/y;
const APC_ESCAPE = /\x1b_[\s\S]*?\x1b\\/y;

function consumeEscapeSequence(text: string, index: number): number {
	for (const pattern of [CSI_ESCAPE, OSC_ESCAPE, APC_ESCAPE]) {
		pattern.lastIndex = index;
		const match = pattern.exec(text);
		if (match) return pattern.lastIndex;
	}
	return index;
}

function consumeCodePoint(text: string, index: number): number {
	const codePoint = text.codePointAt(index);
	if (codePoint === undefined) return index;
	return index + (codePoint > 0xffff ? 2 : 1);
}

function removeFakeCursorFromLine(line: string): string {
	const markerIndex = line.indexOf(CURSOR_MARKER);
	if (markerIndex === -1) return line;

	const cursorStart = markerIndex + CURSOR_MARKER.length;
	let index = cursorStart;

	while (index < line.length) {
		const nextIndex = consumeEscapeSequence(line, index);
		if (nextIndex === index) break;
		index = nextIndex;
	}

	if (index >= line.length) return line;

	const charStart = index;
	const charEnd = consumeCodePoint(line, charStart);
	let suffixStart = charEnd;

	while (suffixStart < line.length) {
		const nextIndex = consumeEscapeSequence(line, suffixStart);
		if (nextIndex === suffixStart) break;
		suffixStart = nextIndex;
	}

	return line.slice(0, cursorStart) + line.slice(charStart, charEnd) + line.slice(suffixStart);
}

class NativeCaretEditor extends CustomEditor {
	render(width: number): string[] {
		return super.render(width).map(removeFakeCursorFromLine);
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		ctx.ui.setEditorComponent((tui, theme, keybindings) => new NativeCaretEditor(tui, theme, keybindings));
	});
}
