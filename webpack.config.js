const path = require('path');
const Watchpack = require('watchpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const SwiftWebpackPlugin = require('@swiftwasm/swift-webpack-plugin')

const outputPath = path.resolve(__dirname, 'dist');

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
