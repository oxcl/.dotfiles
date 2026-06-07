import fs from 'node:fs/promises';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { Pixel, fg } from './pixel';

let cachedFrame: string[] | null = null;
let cachedFramePixels: Pixel[][] | null = null;

const FRAME_COLOR: [number, number, number] = [100, 100, 100]; // dim gray

export async function loadFrame(): Promise<string[]> {
  if (cachedFrame) return cachedFrame;
  
  const baseDir = dirname(fileURLToPath(import.meta.url));
  const text = await fs.readFile(`${baseDir}/frame.txt`, 'utf-8');
  cachedFrame = text.split('\n');
  return cachedFrame;
}

export function renderFrame(lines: string[]): Pixel[][] {
  if (cachedFramePixels) return cachedFramePixels;
  
  const [r, g, b] = FRAME_COLOR;
  const colorEscape = fg(r, g, b);
  
  cachedFramePixels = lines.map(line => {
    return Array.from(line).map(char => {
      if (char === '|' || char === '_') {
        return { char, fg: colorEscape, bold: true };
      }
      return { char: 't', fg: '', bold: false };
    });
  });
  
  return cachedFramePixels;
}
