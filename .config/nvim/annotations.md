# Annotations

## Environment

### Windows

Dec 01, 2018

To continue adding to this pile, I remember there being a need to configure the cursor
for tmux and nvim differently when using konsole.

```vim
let s:konsole = exists('$KONSOLE_DBUS_SESSION') ||
\ exists('$KONSOLE_PROFILE_NAME')
```
...

```vim
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
let s:normal_shape = 0
let s:insert_shape = 5
let s:replace_shape = 3

elseif s:iterm || s:konsole
let s:start_insert = "\<Esc>]50;CursorShape=" . s:insert_shape . "\x7"
let s:start_replace = "\<Esc>]50;CursorShape=" . s:replace_shape . "\x7"
let s:end_insert = "\<Esc>]50;CursorShape=" . s:normal_shape . "\x7"
else
let s:cursor_shape_to_vte_shape = {1: 6, 2: 4, 0: 2, 5: 6, 3: 4}
let s:insert_shape = s:cursor_shape_to_vte_shape[s:insert_shape]
let s:replace_shape = s:cursor_shape_to_vte_shape[s:replace_shape]
let s:normal_shape = s:cursor_shape_to_vte_shape[s:normal_shape]
let s:start_insert = "\<Esc>[" . s:insert_shape . ' q'
let s:start_replace = "\<Esc>[" . s:replace_shape . ' q'
let s:end_insert = "\<Esc>[" . s:normal_shape . ' q'
endif
```

From: <https://github.com/rafi/vim-config/blob/master/config/terminal.vim#L39>

Typically don't like working with escape sequences.
Gotta admit that's a lot smarter than what I'd come up with.

Now here are some functions that don't work.

## Plugins

### LanguageClient

Just ran this doozy to setup the build for termux.

`%s/\/tmp/\/data\/data\/com.termux\/files\/usr\/tmp`

### UltiSnips

From the help pages.

#### Check if text is expandable

    6. FAQ   *UltiSnips-FAQ*

    Q: Do I have to call UltiSnips#ExpandSnippet() to check if a snippet is
    expandable? Is there instead an analog of neosnippet#expandable?
    A: Yes there is, try

    ```vim
    function UltiSnips#IsExpandable()
        return !empty(UltiSnips#SnippetsInCurrentScope())
    endfunction
    ```
    Consider that UltiSnips#SnippetsInCurrentScope() will return all the
    snippets you have if you call it after a space character. If you want
    UltiSnips#IsExpandable() to return false when you call it after a space
    character use this a bit more complicated implementation:

    `function UltiSnips#IsExpandable()`

As notated by folds, go to All --> Remaining Plugins --> UltiSnips. Should be
around line 700.

I've copied `UltiSnips#IsExpandable()` there, and wanted to list the explanation
here so as to note clutter up my [init.vim](init.vim).

However that func needs a mapping because I'm never going to remember it.
