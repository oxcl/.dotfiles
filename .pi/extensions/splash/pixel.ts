export interface Pixel {
  char: string;
  fg: string;  // foreground color escape code (e.g. \x1b[38;2;R;G;Bm)
  bold: boolean;
}

export const RESET = '\x1b[0m';

export const EMPTY: Pixel = {
  char: ' ',
  fg: '',
  bold: false
};

export function fg(r: number, g: number, b: number): string {
  return `\x1b[38;2;${r};${g};${b}m`;
}

export const BOLD = '\x1b[1m';
export const BOLD_OFF = '\x1b[22m';
