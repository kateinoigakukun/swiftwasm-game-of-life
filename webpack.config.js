const path = require('path');
const Watchpack = require('watchpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const SwiftWebpackPlugin = require('@swiftwasm/swift-webpack-plugin')

const outputPath = path.resolve(__dirname, 'dist');
const staticPath = path.resolve(__dirname, 'static');

module.exports = {
  entry: './src/index.js',
  mode: 'development',
  output: {
    filename: 'main.js',
    path: outputPath,
  },
  devServer: {
    watchContentBase: true,
    contentBase: [
      staticPath,
      outputPath,
    ],
  },
  plugins: [
    new SwiftWebpackPlugin({
      packageDirectory: path.join(__dirname, 'LifeGame'),
      target: 'LifeGameWeb',
      dist: outputPath
    }),
    new HtmlWebpackPlugin({
      template: path.join(staticPath, 'index.html'),
    }),
  ],
};
