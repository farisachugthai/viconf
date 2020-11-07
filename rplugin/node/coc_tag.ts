#!/usr/bin/env node
// @ts-ignore
import * as cp from 'child_process';
// import * as date from 'date';
import * as fs from 'fs';
import * as path from 'path';
import * as readline from 'readline';
import * as util from 'util';

import pkg from 'coc.nvim';
const { sources, workspace } = pkg;
import { ExtensionContext } from 'coc.nvim';

const TAG_CACHE = {};
const { nvim } = workspace;

// type AutoDetect = 'on' | 'off';

export function exists(file: string): Promise<boolean> {
	return new Promise<boolean>((resolve, _reject) => {
		fs.exists(file, (value) => {
			resolve(value);
		});
	});
}

export function exec(command: string, options: cp.ExecOptions): Promise<{ stdout: string; stderr: string }> {
	return new Promise<{ stdout: string; stderr: string }>((resolve, reject) => {
		cp.exec(command, options, (error, stdout, stderr) => {
			if (error) {
				reject({ error, stdout, stderr });
			}
			resolve({ stdout, stderr });
		});
    });
}

export async function getTagFiles() {
  let files = await nvim.call("tagfiles");
  if (!files || files.length === 0) {
    return [];
  }
  const cwd = await nvim.call("getcwd");
  files = files.map(f => {
    return path.isAbsolute(f) ? f : path.join(cwd, f);
  });
  const tagfiles: any = [];
  for (const file of files) {
    const stat = await util.promisify(fs.stat)(file);
    if (!stat || !stat.isFile()) {
      continue;
    }
    tagfiles.push({ file, mtime: stat.mtime });
  }
  return tagfiles;
}

export function readFileByLine(fullpath: string, onLine, limit = 50000) {
  const rl = readline.createInterface({
    input: fs.createReadStream(fullpath),
    crlfDelay: Infinity,
    terminal: false
  });
  let n = 0;
  rl.on("line", line => {
    n = n + 1;
    if (n === limit) {
      rl.close();
    } else {
      onLine(line);
    }
  });
  return new Promise((resolve, reject) => {
    rl.on("close", () => {
      resolve();
    });
    rl.on("error", reject);
  });
}

// export async function loadTags(fullpath: string, mtime: date.Date) {
export async function loadTags(fullpath: string, mtime) {
  const item = TAG_CACHE[fullpath];
  if (item && item.mtime >= mtime) {
    return item.words;
  }
  const words = new Map();
  await readFileByLine(fullpath, line => {
    if (line[0] === "!") {
      return;
    }
    const ms = line.split(/\t\s*/);
    if (ms.length < 2) {
      return;
    }
    const [word, path] = ms;
    const wordItem = words.get(word) || [];
    wordItem.push(path);
    words.set(word, wordItem);
  });
  TAG_CACHE[fullpath] = { words, mtime };
  return words;
}

// old way of doing this. unsure if this is async tho
// exports.activate = context => {
export async function activate(context: ExtensionContext): Promise<void> {
  context.subscriptions.push(
    sources.createSource({
      name: "tags",
      shortcut: "Coc-Tag",
      priority: 3,
      doComplete: async function(opt) {
        const { input } = opt;
        if (input.length === 0) {
          return null;
        }
        const tagfiles = await getTagFiles();
        if (!tagfiles || tagfiles.length === 0) {
          return null;
        }
        const list = await Promise.all(
          tagfiles.map(o => loadTags(o.file, o.mtime))
        );
        const items = [];
        for (const words of list) {
          for (const [word, paths] of words.entries()) {
            if (word[0] !== input[0]) {
              continue;
            }
            let infoList = Array.from(new Set(paths));
            const len = infoList.length;
            if (len > 10) {
              infoList = infoList.slice(0, 10);
              infoList.push(`${len - 10} more...`);
            }
            items.push({
              word,
              info: infoList.join("\n")
            });
          }
        }
        return { items };
      }
    })
  );
};
