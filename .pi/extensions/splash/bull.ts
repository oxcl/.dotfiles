import fs from 'node:fs/promises';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { Pixel, EMPTY, fg } from './pixel';

let cachedBull: string[] | null = null;

export async function loadBull(): Promise<string[]> {
  if (cachedBull) return cachedBull;
  
  const baseDir = dirname(fileURLToPath(import.meta.url));
  const text = await fs.readFile(`${baseDir}/bull.txt`, 'utf-8');
  cachedBull = text.split('\n');
  return cachedBull;
}

// Smooth gradient stops - teal to cyan
const GRADIENT: [number, number, number, number][] = [
  [0.0, 30, 160, 160],   // teal
  [0.25, 40, 170, 175],  // teal-cyan
  [0.5, 50, 185, 190],   // cyan
  [0.75, 55, 195, 210],  // light cyan
  [1.0, 60, 200, 220],   // bright cyan
];

function lerpGradient(t: number): [number, number, number] {
  const tt = Math.max(0, Math.min(1, t));
  
  let i = 0;
  while (i < GRADIENT.length - 1 && GRADIENT[i + 1][0] < tt) {
    i++;
  }
  
  if (i >= GRADIENT.length - 1) {
    const [, r, g, b] = GRADIENT[GRADIENT.length - 1];
    return [r, g, b];
  }
  
  const [t0, r0, g0, b0] = GRADIENT[i];
  const [t1, r1, g1, b1] = GRADIENT[i + 1];
  const f = (tt - t0) / (t1 - t0);
  
  return [
    Math.round(r0 + (r1 - r0) * f),
    Math.round(g0 + (g1 - g0) * f),
    Math.round(b0 + (b1 - b0) * f)
  ];
}

let cachedBullStructure: { char: string; isSolid: boolean }[][] | null = null;
let bullBuffer: Pixel[][] | null = null;

function getBullStructure(lines: string[]): { char: string; isSolid: boolean }[][] {
  if (cachedBullStructure) return cachedBullStructure;
  
  cachedBullStructure = lines.map(line => {
    return Array.from(line).map(char => ({
      char,
      isSolid: char !== 't' && char !== ' '
    }));
  });
  
  return cachedBullStructure;
}

function ensureBullBuffer(height: number, width: number): Pixel[][] {
  if (bullBuffer && bullBuffer.length === height && bullBuffer[0].length === width) return bullBuffer;
  
  bullBuffer = Array.from({ length: height }, () =>
    Array.from({ length: width }, () => ({ char: ' ', fg: '', bold: false }))
  );
  return bullBuffer;
}

export function renderBull(lines: string[], frame: number): Pixel[][] {
  const structure = getBullStructure(lines);
  const maxWidth = structure.reduce((max, row) => Math.max(max, row.length), 0);
  const pixels = ensureBullBuffer(structure.length, maxWidth);
  
  for (let y = 0; y < structure.length; y++) {
    const sRow = structure[y];
    const pRow = pixels[y];
    for (let x = 0; x < sRow.length; x++) {
      const { char, isSolid } = sRow[x];
      const pixel = pRow[x];
      if (!pixel) continue;
      
      if (!isSolid) {
        pixel.char = char;
        pixel.fg = '';
        pixel.bold = false;
        continue;
      }
      
      // Animated gradient - shifts diagonally
      const t = (Math.sin((x + y) * 0.15 + frame * 0.03) + 1) * 0.5;
      const [r, g, b] = lerpGradient(t);
      
      pixel.char = char;
      pixel.fg = fg(r, g, b);
      pixel.bold = true;
    }
  }
  
  return pixels;
}
