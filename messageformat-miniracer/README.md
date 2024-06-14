# messageformat-miniracer

This package manages our MiniRacer-consumable copy of the [`@messageformat/core` library](https://www.npmjs.com/package/@messageformat/core). The `dist/compilemodule.js` and `dist/messageformat.js` files in this gem (parent directory of this directory) is what MiniRacer consumes and it contains the `@messageformat/core` library and all of its dependencies.

To upgrade the `@messageformat/core` version that we use in MiniRacer:

1. Bump the version number of `@messageformat/core` in the `package.json` file in this directory to the desired version

2. Run `yarn install` in this directory followed by `yarn webpack`. The latter command is only needed locally. Our GitHub actions will take care of it when publishing the gem.

The last command rebuilds the `dist/compilemodule.js` and `dist/messageformat.js` files with the version of `@messageformat/core` that's specified in the `package.json` file. You need to then commit the changes you've made to `package.json` as well as any changes that are made to `yarn.lock`.
