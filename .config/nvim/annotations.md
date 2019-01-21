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

" Environment: {{{ 2

```vim
let s:termux = exists('$PREFIX') && has('unix')
let s:ubuntu = !exists('$PREFIX') && has('unix')
let s:windows = has('win32') || has('win64')

" function! is#termux() abort
"     return s:termux
" endfunction

" function! is#ubuntu() abort
"     return s:ubuntu
" endfunction

" function! is#windows() abort
"     return s:windows
" endfunction
```


```vim
" Gonna start seriously consolidating vimrc and init.vim this is so hard
" to maintain
" Let's setup all the global vars we need
" Wait am i assigning these vars correctly? man fuck vimscript

if has('nvim')
    let s:root = '~/.config/nvim'
    let s:conf = '~/.config/nvim/init.vim'
else
    let s:root = '~/.vim'
    let s:conf = '~/.vim/vimrc'
endif

if exists('$PREFIX')
    let s:usr_d = '$PREFIX'     " might need to expand on use
    let s:OS= 'Android'
else
    let s:usr_d = '/usr'
    let s:OS = 'Linux'
endif
```

## Plugins

### LanguageClient

Just ran this doozy to setup the build for termux.
%s/\/tmp/\/data\/data\/com.termux\/files\/usr\/tmp

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
here so as to note clutter up my init.vim.

However that func needs a mapping because I'm never gonna remember it.

### Neosnippets

```vim
" Because I've found UltiSnips quite challenging to work with.
let g:neosnippet#snippets_directory = [ '~/.config/nvim/neosnippets', '~/.local/share/nvim/plugged/vim-snippets/snippets' ]

" From the help pages:
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets' behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
\ pumvisible() ? "\<C-n>" :
\ neosnippet#expandable_or_jumpable() ?
\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" This errors out.
" Expand the completed snippet trigger by <CR>.
" imap <expr><CR>
" \ (pumvisible() && neosnippet#expandable()) ?
" \<Plug>(neosnippet_expand)" : "\<CR>"

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
```

### Lightline

Honestly keep this around because airline is pretty heavy on termux.

TODO: What I need to do is write a function that works as a guard for plugins.

```vim
if !haskey('plugs', 'lightline')
    break
elseif loaded_lightline
    break
else
    let g:loaded_lightline = 1
```

Then just pad every plugin file you have like [FZF](./after/plugin/fzf.vim)
with one of those and you'll be set.

```vim
" Lightline: {{{
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head',
    \   'filetype': 'MyFiletype',
    \   'fileformat': 'MyFileformat',
    \ },
    \ }


" function! MyFiletype()
"     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
" endfunction


" function! MyFileformat()
"     return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
" endfunction

" let g:lightline.colorscheme = 'seoul256'
" }}}
```
