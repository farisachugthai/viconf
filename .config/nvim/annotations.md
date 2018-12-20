# Annotations

## Windows

" Environment: {{{ 2
" Let's setup all the global vars we need. Will utilize to ensure consistency

let s:termux = exists('$PREFIX') && has('unix')
let s:ubuntu = !exists('$PREFIX') && has('unix')
let s:windows = has('win32') || has('win64')

" So what I think my problem was is that I have these variables but there's
" no point at which they're initialized. Let's write a few funcs
" function! is#termux() abort
"     return s:termux
" endfunction

" function! is#ubuntu() abort
"     return s:ubuntu
" endfunction

" function! is#windows() abort
"     return s:windows
" endfunction
" }}}


## Plugins

=====================================================================

### FZF and friends

So between fzf, ag, rg and a ton of other things I"ve been trying to do a ton with configuring searches correctly.

Look at the command vscode gives you if you enable experimental support for rg.

    `rg --files --hidden --case-sensitive -g '**/package.json' -g '!**/node_modules/**' -g '!**/.git' -g '!**/.svn' -g '!**/.hg' -g '!**/CVS' -g '!**/.DS_Store' --no-ignore-parent --follow --no-config --no-ignore-global -- '.'`

I mean I guess it wouldn't hurt to try integrating that into the init right?

### Language Client

The only thing is the function

    `LanguageClient_serverCommands()`

But it's a simple dictionary. If you want, run a whole mess of loops checking
things you care about I.E. bash language server, pyls etc are executable.

If those loops return True, add it's name to the dictionary. Then have the
server run the commands we feed to it

I'm not sure how I hadn't thought of this yet.

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
