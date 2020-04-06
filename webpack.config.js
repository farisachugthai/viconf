const path = require('path')
const cp = require('child_process')
const webpack = require('./node_modules/webpack')

let res = cp.execSync('git rev-parse HEAD', {encoding: 'utf8'})
let revision = res.slice(0, 10)

module.exports = {
  entry: './rplugin/node/coc_tag',
  target: 'node',
  mode: 'development',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'index.js'
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.REVISION': JSON.stringify(revision)
    })
  ],
  node: {
    __filename: false,
    __dirname: false
  }
}
