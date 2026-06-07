import { Pixel, EMPTY, fg } from './pixel';

const FIRE_WIDTH = 42;
const FIRE_HEIGHT = 22;

const FIRE_CHARS = [' ', ' ', '.', '.', ':', '*', '#'];

// Fire color gradient stops (intensity, r, g, b)
const FIRE_GRADIENT: [number, number, number, number][] = [
  [0.0, 30, 0, 0],      // dark red
  [0.15, 70, 5, 0],     // red
  [0.3, 120, 15, 0],    // medium red
  [0.45, 160, 30, 0],   // red-orange
  [0.6, 180, 60, 0],    // orange
  [0.75, 200, 110, 0],  // bright orange
  [0.85, 220, 150, 20], // yellow-orange
  [0.95, 240, 190, 60], // yellow
  [1.0, 255, 220, 100], // bright yellow
];

// Interpolate between gradient stops, returns [r, g, b]
function fireColorRGB(intensity: number): [number, number, number] {
  const t = Math.max(0, Math.min(1, intensity));
  
  let i = 0;
  while (i < FIRE_GRADIENT.length - 1 && FIRE_GRADIENT[i + 1][0] < t) {
    i++;
  }
  
  if (i >= FIRE_GRADIENT.length - 1) {
    const [, r, g, b] = FIRE_GRADIENT[FIRE_GRADIENT.length - 1];
    return [r, g, b];
  }
  
  const [t0, r0, g0, b0] = FIRE_GRADIENT[i];
  const [t1, r1, g1, b1] = FIRE_GRADIENT[i + 1];
  const f = (t - t0) / (t1 - t0);
  
  return [
    Math.round(r0 + (r1 - r0) * f),
    Math.round(g0 + (g1 - g0) * f),
    Math.round(b0 + (b1 - b0) * f)
  ];
}

// Simple pseudo-random based on seed
function random(seed: number): number {
  const x = Math.sin(seed) * 10000;
  return x - Math.floor(x);
}

// Get fire intensity at position based on frame
function getFireIntensity(x: number, y: number, frame: number): number {
  const nx = x / FIRE_WIDTH;
  const ny = y / FIRE_HEIGHT;
  const invNy = 1 - ny;
  
  // Flame shape - teardrop, wider at base
  const centerX = 0.5;
  const baseWidth = 0.8;
  const flameWidth = baseWidth * Math.pow(invNy, 0.5);
  const distFromCenter = Math.abs(nx - centerX);
  
  let shape = Math.max(0, 1 - Math.pow(distFromCenter / flameWidth, 2));
  
  // Height fade - fire reaches full height
  const heightFade = Math.max(0, 1 - ny * ny);
  
  let intensity = shape * heightFade * 0.7;
  
  // Flame tongues - rising columns of fire that sway
  const tongue1 = Math.exp(-Math.pow((nx - 0.35 + Math.sin(frame * 0.06) * 0.08) * 5, 2));
  const tongue2 = Math.exp(-Math.pow((nx - 0.55 + Math.sin(frame * 0.04 + 1) * 0.1) * 4, 2));
  const tongue3 = Math.exp(-Math.pow((nx - 0.7 + Math.sin(frame * 0.07 + 2) * 0.07) * 6, 2));
  
  const tongueHeight1 = Math.exp(-ny * 3) * tongue1;
  const tongueHeight2 = Math.exp(-ny * 4) * tongue2;
  const tongueHeight3 = Math.exp(-ny * 5) * tongue3;
  
  intensity += (tongueHeight1 + tongueHeight2 + tongueHeight3) * 0.4 * heightFade;
  
  // Turbulence - makes edges flicker
  const turb = Math.sin(nx * 15 + frame * 0.1) * Math.sin(ny * 10 - frame * 0.15) * 0.15;
  intensity += turb * shape * heightFade;
  
  // Smooth flicker
  const f1 = random(x * 7 + y + Math.floor(frame * 0.4));
  const f2 = random(x * 7 + y + Math.floor(frame * 0.4) + 1);
  const flicker = (f1 + (f2 - f1) * ((frame * 0.4) % 1)) * 0.2 * shape;
  intensity += flicker * heightFade;
  
  // Hot embers at base
  if (ny > 0.8 && shape > 0 && heightFade > 0) {
    const e1 = random(x + Math.floor(frame * 0.2));
    const e2 = random(x + Math.floor(frame * 0.2) + 1);
    const ember = (e1 + (e2 - e1) * ((frame * 0.2) % 1)) * 0.6 * shape * heightFade;
    intensity = Math.max(intensity, ember);
  }
  
  return Math.max(0, Math.min(1, intensity));
}

function getChar(intensity: number): string {
  const index = Math.floor(intensity * (FIRE_CHARS.length - 1));
  return FIRE_CHARS[index];
}

/**
 * Renders an ASCII art fire animation frame
 * @param frame - Frame number for animation
 * @returns 2D array of Pixels (42x22)
 */
let fireBuffer: Pixel[][] | null = null;

function ensureFireBuffer(): Pixel[][] {
  if (fireBuffer) return fireBuffer;
  
  fireBuffer = Array.from({ length: FIRE_HEIGHT }, () =>
    Array.from({ length: FIRE_WIDTH }, () => ({ char: ' ', fg: '', bold: false }))
  );
  return fireBuffer;
}

export function renderFire(frame: number): Pixel[][] {
  const pixels = ensureFireBuffer();
  
  // Fill bottom-to-top, but buffer is stored top-to-bottom (reversed)
  for (let y = 0; y < FIRE_HEIGHT; y++) {
    const srcY = FIRE_HEIGHT - 1 - y;
    const row = pixels[y];
    for (let x = 0; x < FIRE_WIDTH; x++) {
      const intensity = getFireIntensity(x, srcY, frame);
      const [r, g, b] = fireColorRGB(intensity);
      const pixel = row[x];
      pixel.char = getChar(intensity);
      pixel.fg = fg(r, g, b);
    }
  }
  
  return pixels;
}
