# Annotations

## FZF

" {{{

Dropping this because FZF.vim now comes with :R and :Rg but if you wanna
modify anything in the future here's the original code I had

```viml
" **TODO**: Commented out because E183: User defined commands must start with an uppercase letter:::
" :ag  - start fzf with hidden preview window that can be enabled with '?' key
" :ag! - start fzf in fullscreen and display the preview window above
" command! -bang -nargs=* ag
"     \ call fzf#vim#ag(<q-args>,
"     \ <bang>0 ? fzf#vim#with_preview('up:60%')
"     \ : fzf#vim#with_preview('right:50%:hidden', '?'),
"     \ <bang>0)

" " similarly, we can apply it to fzf#vim#grep. to use ripgrep instead of ag:
" command! -bang -nargs=* rg
"     \ call fzf#vim#grep(
"     \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
"     \ <bang>0 ? fzf#vim#with_preview('up:60%')
"     \ : fzf#vim#with_preview('right:50%:hidden', '?'),
"     \ <bang>0)

" " likewise, files command with preview window
" command! -bang -nargs=? -complete=dir files
"     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
```
" }}}

## Environment

Dec 01, 2018

To continue adding to this pile, I remember there being a need to configure the cursor
for tmux and nvim differently when using konsole.

```viml
let s:konsole = exists('$KONSOLE_DBUS_SESSION') ||
\ exists('$KONSOLE_PROFILE_NAME')
```
...

```viml
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
Gotta admit that's a lot smarter than what i'd come up with.


" Environment: {{{ 2

Doesn't work.

```viml
" Let's setup all the global vars we need. Will utilize to ensure consistency

let s:termux = exists('$PREFIX')
let s:ubuntu = !exists('$PREFIX') && has('unix')  " syntax?
```

Just pulled this off of the vimrc. The one above is init.vim.
Both from laptop branch not termux. Amazingly there's different
attempts over there too.

" Nvim_OS: {{{ 2
```viml
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
" }}}

" }}}

## Plugins

" {{{

### UltiSnips

#### Check if text is expandable

6. FAQ                                                        *UltiSnips-FAQ*

Q: Do I have to call UltiSnips#ExpandSnippet() to check if a snippet is
   expandable? Is there instead an analog of neosnippet#expandable?
A: Yes there is, try

  function UltiSnips#IsExpandable()
    return !empty(UltiSnips#SnippetsInCurrentScope())
  endfunction

  Consider that UltiSnips#SnippetsInCurrentScope() will return all the
  snippets you have if you call it after a space character. If you want
  UltiSnips#IsExpandable() to return false when you call it after a space
  character use this a bit more complicated implementation:

  function UltiSnips#IsExpandable()

As notated by folds, go to All --> Remaining Plugins --> UltiSnips. Should be
around line 700.

I've copied UltiSnips#IsExpandable() there, and wanted to list the explanation
here so as to note clutter up my init.vim.

However that func needs a mapping because I'm never gonna remember it.

### Language Client

The only thing is the function LanguageClient_serverCommands()

But it's a simple dictionary. If you want, run a whole mess of loops checking
things you care about I.E. bash language server, pyls etc are executable.

If those loops return True, add it's name to the dictionary. Then have the
server run the commands we feed to it

I'm not sure how I hadn't thought of this yet.

### Neosnippets

```viml
" Neosnippets: {{{

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
" }}}
```

### Lightline

Honestly keep this around because airline is pretty heavy on termux.

BTW do the code blocks need viml or VimScript after the tick marks?

```viml
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

### NerdCom

TODO: Use :Glog to recover your old nerdcom code. Better do it soon if you're
thinking about ever being able to use it again!

" }}}
