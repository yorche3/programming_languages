import { readFile } from 'fs/promises';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const wasmPath = `${__dirname}/build/release.wasm`;

async function getStringFromMemory(instance, ptr) {
  const memory = new Uint8Array(instance.exports.memory.buffer);
  const view = new DataView(instance.exports.memory.buffer);

  // The string length is stored 4 bytes before the pointer
  const len = view.getUint32(ptr - 4, true); // little-endian
  const bytes = memory.subarray(ptr, ptr + len);
  const decoder = new TextDecoder('utf-8');
  return decoder.decode(bytes);
}

async function main() {
  try {
    const wasmBuffer = await readFile(wasmPath);

    const env = {
      abort: () => {
        console.error('abort called');
        throw new Error('abort called');
      },
    };

    const { instance } = await WebAssembly.instantiate(wasmBuffer, { env });

    // Call the exported `hello()` function
    const ptr = instance.exports.hello();

    // Read the string from memory
    const message = await getStringFromMemory(instance, ptr);
    console.log('Message from WebAssembly:', message);
  } catch (err) {
    console.error('Error:', err);
  }
}

main();