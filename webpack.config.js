const path = require("path");
const cp = require("child_process");
const webpack = require("./node_modules/webpack");
const coc_nvim = require("./node_modules/coc.nvim");

let res = cp.execSync("git rev-parse HEAD", {encoding: "utf8"});
let revision = res.slice(0, 10);

module.exports = {
  entry: "./rplugin/node/coc_tag",
  target: "node",
  mode: "development",
  module: {
    rules: [
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        use: [
          {
            loader: "ts-loader",
            options: {
              compilerOptions: {
                sourceMap: true
              }
            }
          }
        ]
      }
    ]
  },

  output: {
    path: path.resolve(__dirname, "build"),
    libraryTarget: "commonjs",
    filename: "index.js"
  },
  resolve: {
    mainFields: ["module", "main"],
    extensions: [".js", ".ts"]
  },
  externals: {
    "coc.nvim": "commonjs coc.nvim",
    typescript: "commonjs typescript"
  },
  plugins: [
    new webpack.DefinePlugin({
      "process.env.REVISION": JSON.stringify(revision)
    })
  ],
  node: {
    __filename: false,
    __dirname: false
  }
};
