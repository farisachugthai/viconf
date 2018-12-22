# Annotations

## Windows

" Environment: {{{ 2
" Let's setup all the global vars we need. Will utilize to ensure consistency

```vim
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
```

Dec 01, 2018: This doesn't work either

```vim
" let s:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/winrc'
" if call(is#windows)         " doubt this is the right syntax but we're getting close
"     if filereadable(s:winrc)
"         exe 'so' s:winrc
"     endif
" endif
```

Just pulled this off of the vimrc. The one above is init.vim.
Both from laptop branch not termux. Amazingly there's different
attempts over there too.


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

" **UNTESTED**:

" just a thought i had. For any normal mode remaps you have, add the same
" thing and prefix <Esc> to the RHS and boom!

```vim
if has('b:Tagbar')  " or any plugin
    let g:tagbar_sort=0
    inoremap <F3> <esc>:TagbarToggle<CR>
    nnoremap <F3> :TagbarToggle<CR>
endif
```
