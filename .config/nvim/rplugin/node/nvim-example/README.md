# neovim-client

| CI (Linux, macOS, Windows) | Coverage | npm | Gitter |
|----------------------------|----------|-----|--------|
| [![Build Status](https://dev.azure.com/neovim/node-client/_apis/build/status/neovim.node-client?branchName=master)](https://dev.azure.com/neovim/node-client/_build/latest?definitionId=1&branchName=master) | [![Coverage Badge][]][Coverage Report] | [![npm version][]][npm package] | [![Gitter Badge][]][Gitter] |

Currently tested for node >= 8


## My personal notes

May 22, 2019:

As I'm sure you surmised this is the README from neovim's node client repo.

Has good code examples and I'm gonna drop their example right here as well.

## Installation
Install the `neovim` package globally using `npm`.

```sh
npm install -g neovim
```

A global package is required for neovim to be able to communicate with a plugin.

## Usage
This package exports a single `attach()` function which takes a pair of
write/read streams and invokes a callback with a Nvim API object.

### `attach`

```js
const cp = require('child_process');
const attach = require('neovim').attach;

const nvim_proc = cp.spawn('nvim', ['-u', 'NONE', '-N', '--embed'], {});

// Attach to neovim process
(async function() {
  const nvim = await attach({ proc: nvim_proc });
  nvim.command('vsp');
  nvim.command('vsp');
  nvim.command('vsp');
  const windows = await nvim.windows;

  // expect(windows.length).toEqual(4);
  // expect(windows[0] instanceof nvim.Window).toEqual(true);
  // expect(windows[1] instanceof nvim.Window).toEqual(true);

  nvim.window = windows[2];
  const win = await nvim.window;

  // expect(win).not.toEqual(windows[0]);
  // expect(win).toEqual(windows[2]);

  const buf = await nvim.buffer;
  // expect(buf instanceof nvim.Buffer).toEqual(true);

  const lines = await buf.lines;
  // expect(lines).toEqual(['']);

  await buf.replace(['line1', 'line2'], 0);
  const newLines = await buf.lines;
  // expect(newLines).toEqual(['line1', 'line2']);

  nvim.quit();
  nvim_proc.disconnect();
})();
```

## Writing a Plugin
A plugin can either be a file or folder in the `rplugin/node` directory. If the plugin is a folder, the `main` script from `package.json` will be loaded.

The plugin should export a function which takes a `NvimPlugin` object as its only parameter. You may then register autocmds, commands and functions by calling methods on the `NvimPlugin` object. You should not do any heavy initialisation or start any async functions at this stage, as nvim may only be collecting information about your plugin without wishing to actually use it. You should wait for one of your autocmds, commands or functions to be called before starting any processing.

`console` has been replaced by a `winston` interface and `console.log` will call `winston.info`.

### API

```ts
  NvimPlugin.nvim
```

This is the nvim api object you can use to send commands from your plugin to nvim.

```ts
  NvimPlugin.setOptions(options: NvimPluginOptions);

  interface NvimPluginOptions {
    dev?: boolean;
    alwaysInit?: boolean;
  }
```

Set your plugin to dev mode, which will cause the module to be reloaded on each invocation.
`alwaysInit` will always attempt to attempt to re-instantiate the plugin. e.g. your plugin class will
always get called on each invocation of your plugin's command.


```ts
  NvimPlugin.registerAutocmd(name: string, fn: Function, options: AutocmdOptions): void;
  NvimPlugin.registerAutocmd(name: string, fn: [any, Function], options: AutocmdOptions): void;

  interface AutocmdOptions {
    pattern: string;
    eval?: string;
    sync?: boolean;
  }
```

Registers an autocmd for the event `name`, calling your function `fn` with `options`. Pattern is the only required option. If you wish to call a method on an object you may pass `fn` as an array of `[object, object.method]`.

By default autocmds, commands and functions are all treated as asynchronous and should return `Promises` (or should be `async` functions).

```ts
  NvimPlugin.registerCommand(name: string, fn: Function, options?: CommandOptions): void;
  NvimPlugin.registerCommand(name: string, fn: [any, Function], options?: CommandOptions): void;

  interface CommandOptions {
    sync?: boolean;
    range?: string;
    nargs?: string;
  }
```

Registers a command named by `name`, calling function `fn` with `options`. This will be invoked from nvim by entering `:name` in normal mode.

```ts
  NvimPlugin.registerFunction(name: string, fn: Function, options?: NvimFunctionOptions): void;
  NvimPlugin.registerFunction(name: string, fn: [any, Function], options?: NvimFunctionOptions): void;
