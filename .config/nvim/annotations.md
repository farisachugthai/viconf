# Annotations

## Environment

To explain what's going on here, I want to use a few environment variables to
determine what platform I'm working on. Then we can use that to set some script
vars, and use them for quick lookups to correctly handle platform specific code.

However, vimscript is terrible and I'm struggling to get anything working.

At a point I may embed some python but I'm concerned that that'll greatly slow
down startup.

Regardless there's no reason to scrap the entire section but none of it works.
So here it is.


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

So between FZF, ag, rg and a ton of other things I've been trying to do a ton with configuring searches correctly.

### Language Client

The only part of the API that was open at the time of writing was the function

    `LanguageClient_serverCommands()`

But it's a simple dictionary. If you want, run a whole mess of loops checking
things you care about I.E. bash language server, pyls etc are executable.
If those loops return True, add it's name to the dictionary. Then have the
server run the commands we feed to it
I'm not sure how I hadn't thought of this yet.

### Lightline

Honestly keep this around because airline is pretty heavy on termux.

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

## functions

### compilers

Now out of curiosity would this go in .config/nvim/compilers?

Compiler Function: {{{

All in one compiler. Going to need to rewrite to make my own.

```Viml
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
