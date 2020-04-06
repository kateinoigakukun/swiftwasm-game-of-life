const path = require('path');
const { spawn } = require('child_process');
const Watchpack = require('watchpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const outputPath = path.resolve(__dirname, 'dist');

function runProcess(bin, args, options) {
  return new Promise((resolve, reject) => {
    const p = spawn(bin, args, options);

    p.on('close', code => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error("Swift compilation."));
      }
    });

    p.stderr.on('data', (data) => {
        console.log(data.toString());
    });
    p.on('error', reject);
  });
}

class SwiftWebpackPlugin {
  constructor(options) {
    this.packageDirectory = options.packageDirectory
    this.target = options.target
    this.dist = options.dist
    this.wp = new Watchpack();
  }
  apply(compiler) {
    compiler.hooks.beforeCompile.tap("SwiftWebpackPlugin", () => {
      if(compiler.watchMode) {
        console.log("Watching: ", path.join(this.packageDirectory, 'Sources'))
        this.wp.watch(
          [path.join(this.packageDirectory, 'Package.swift')],
          [path.join(this.packageDirectory, 'Sources')],
          Date.now() - 10000
        );
        this.wp.on('change', () => {
          this._compile();
        })
      }
    })
    compiler.hooks.compile.tap("SwiftWebpackPlugin", compilation => {
      this._compile();
    });
  }

  _compile() {
      const options = {
	cwd: this.packageDirectory,
      }
      runProcess(
	"swiftenv",
	["exec", "swift", "build", "--triple", "wasm32-unknown-wasi"],
	options
      ).then(() => {
	runProcess(
	  "cp",
	  [
	    path.join(this.packageDirectory, '.build/debug', this.target),
	    path.join(this.dist, this.target + ".wasm"),
	  ]
	);
      })
  }
}

module.exports = {
  entry: './src/index.js',
  mode: 'development',
  output: {
    filename: 'main.js',
    path: outputPath,
  },
  devServer: {
    inline: true,
    watchContentBase: true,
    contentBase: [
      path.join(__dirname, 'public'),
      path.join(__dirname, 'dist'),
    ],
  },
  plugins: [
    new SwiftWebpackPlugin({
      packageDirectory: path.join(__dirname, 'LifeGame'),
      target: 'LifeGameWeb',
      dist: path.join(__dirname, "dist")
    }),
    new HtmlWebpackPlugin({
      template: path.resolve('./public/index.html'),
    }),
  ],
};
