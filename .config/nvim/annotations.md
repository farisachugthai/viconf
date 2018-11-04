# Annotations

## Environment

" Environment: {{{ 2

Doesn't work.

```viml
" Let's setup all the global vars we need. Will utilize to ensure consistency

let s:termux = exists('$PREFIX')
let s:ubuntu = !exists('$PREFIX') && has('unix')  " syntax?
```
" }}}

## Plugins

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

## functions

### compilers

Now out of curiosity would this go in .config/nvim/compilers?

Compiler Function: {{{

All in one compiler. Going to need to rewrite to make my own.

```
noremap <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc
```

}}}

### ALE

....what the hell is this?
{As in what does this syntax mean if you're reading feel free to create an issue and let me know}

```viml
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '' : printf( '%dW %dE', l:all_non_errors, l:all_errors )
endfunction
```
