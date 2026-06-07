import { Pixel, RESET, BOLD, BOLD_OFF } from './pixel';

interface Layer {
  pixels: Pixel[][];
  x: number;
  y: number;
}

interface RenderState {
  fg: string;
  bold: boolean;
}

/**
 * Composite multiple pixel layers into a single string array
 * Layers are drawn in order - later layers appear on top
 * 't' character is transparent
 */
let compositeBuffer: Pixel[][] | null = null;
let compositeWidth = 0;
let compositeHeight = 0;

function ensureCompositeBuffer(height: number, width: number): Pixel[][] {
  if (compositeBuffer && compositeHeight === height && compositeWidth === width) {
    // Clear existing buffer
    for (let y = 0; y < height; y++) {
      const row = compositeBuffer[y];
      for (let x = 0; x < width; x++) {
        row[x].char = ' ';
        row[x].fg = '';
        row[x].bold = false;
      }
    }
    return compositeBuffer;
  }
  
  compositeWidth = width;
  compositeHeight = height;
  compositeBuffer = Array.from({ length: height }, () =>
    Array.from({ length: width }, () => ({ char: ' ', fg: '', bold: false }))
  );
  return compositeBuffer;
}

export function composite(layers: Layer[]): string[] {
  // Find the bounding box
  let maxWidth = 0;
  let maxHeight = 0;
  
  for (const layer of layers) {
    const h = layer.y + layer.pixels.length;
    maxHeight = Math.max(maxHeight, h);
    
    for (const row of layer.pixels) {
      const w = layer.x + row.length;
      maxWidth = Math.max(maxWidth, w);
    }
  }
  
  // Reuse output buffer
  const buffer = ensureCompositeBuffer(maxHeight, maxWidth);
  
  // Draw layers in order (later layers on top)
  // Later layers merge with earlier ones - only overwrite set properties
  for (const layer of layers) {
    for (let y = 0; y < layer.pixels.length; y++) {
      for (let x = 0; x < layer.pixels[y].length; x++) {
        const pixel = layer.pixels[y][x];
        const bx = layer.x + x;
        const by = layer.y + y;
        
        if (bx >= 0 && bx < maxWidth && by >= 0 && by < maxHeight) {
          // 't' is transparent - skip entirely
          if (pixel.char === 't') continue;
          
          // Merge pixel - only overwrite non-empty properties
          const target = buffer[by][bx];
          target.char = pixel.char;
          if (pixel.fg) target.fg = pixel.fg;
          if (pixel.bold) target.bold = pixel.bold;
        }
      }
    }
  }
  
  // Convert buffer to strings with state machine
  return buffer.map(row => {
    let line = '';
    const state: RenderState = { fg: '', bold: false };
    
    for (const pixel of row) {
      // Bold changes
      if (pixel.bold !== state.bold) {
        line += pixel.bold ? BOLD : BOLD_OFF;
        state.bold = pixel.bold;
      }
      
      // Foreground color changes
      if (pixel.fg !== state.fg) {
        if (pixel.fg) {
          line += pixel.fg;
        } else {
          // Reset fg to default
          line += '\x1b[39m';
        }
        state.fg = pixel.fg;
      }
      
      line += pixel.char;
    }
    
    // Reset at end of line if any state is active
    if (state.fg || state.bold) {
      line += RESET;
    }
    
    return line;
  });
}
