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
  let { instance } = await WebAssembly.instantiateStreaming(fetch("LifeGameWeb.wasm"), {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  });

  swift.setInsance(instance);
  wasi.start(instance);
};
startWasiTask().catch(err => {
  console.error(err);
});
