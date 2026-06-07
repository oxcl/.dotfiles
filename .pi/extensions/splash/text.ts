import fs from 'node:fs/promises';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { Pixel, fg } from './pixel';

let cachedText: string[] | null = null;
let cachedTextPixels: Pixel[][] | null = null;

const TEXT_COLOR: [number, number, number] = [220, 220, 220]; // light gray

export async function loadText(): Promise<string[]> {
  if (cachedText) return cachedText;
  
  const baseDir = dirname(fileURLToPath(import.meta.url));
  const text = await fs.readFile(`${baseDir}/text.txt`, 'utf-8');
  cachedText = text.split('\n');
  return cachedText;
}

export function renderText(lines: string[]): Pixel[][] {
  if (cachedTextPixels) return cachedTextPixels;
  
  const [r, g, b] = TEXT_COLOR;
  const colorEscape = fg(r, g, b);
  
  cachedTextPixels = lines.map(line => {
    return Array.from(line).map(char => {
      if (char !== 't') {
        return { char, fg: colorEscape, bold: true };
      }
      return { char: 't', fg: '', bold: false };
    });
  });
  
  return cachedTextPixels;
}
