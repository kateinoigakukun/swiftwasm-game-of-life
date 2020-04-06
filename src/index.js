import { SwiftRuntime } from "javascript-kit-swift";
import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";


const swift = new SwiftRuntime();
const wasmFs = new WasmFs();
let wasi = new WASI({
  args: [],
  env: {},
  bindings: {
    ...WASI.defaultBindings,
    fs: wasmFs.fs
  }
});

wasmFs.fs.createWriteStream('/dev/stderr', 'utf8').on('data', data => {
  console.error(data.toString());
})

const startWasiTask = async () => {
  const response = await fetch("LifeGameWeb.wasm");
  const responseArrayBuffer = await response.arrayBuffer();

  const wasm_bytes = new Uint8Array(responseArrayBuffer).buffer;
  let { instance } = await WebAssembly.instantiate(wasm_bytes, {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  });

  swift.setInsance(instance);
  wasi.start(instance);
};
startWasiTask().catch(err => {
  console.error(err);
});
