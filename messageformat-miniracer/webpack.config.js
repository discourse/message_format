const path = require("path");

module.exports = {
  devtool: false,
  mode: "production",
  entry: {
    messageformat: {
      import: "@messageformat/core",
      library: {
        type: "var",
        name: "MessageFormat"
      }
    },
    compilemodule: {
      import: "@messageformat/core/compile-module",
      library: {
        type: "var",
        name: "compileModule"
      }
    }
  },
  output: {
    iife: false,
    path: path.resolve(`${__dirname}/../`, "dist"),
  },
};
