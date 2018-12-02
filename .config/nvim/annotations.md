# Annotations

## Environment
---------------

To explain what's going on here, I want to use a few environment variables to
determine what platform I'm working on. Then we can use that to set some script
vars, and use them for quick lookups to correctly handle platform specific code.

However, vimscript is terrible and I'm struggling to get anything working.

At a point I may embed some python but I'm concerned that that'll greatly slow
down startup.

Regardless there's no reason to scrap the entire section but none of it works.
So here it is.

### Handling platform specific code (incorrectly)

```viml
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
```

### Sourcing configs for Win32

Also doesn't work. Still wanna continue with it later but don't want it
cluttering my vimrc.

```viml
" let s:winrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/winrc'
" if call(is#windows)         " doubt this is the right syntax but we're getting close
"     if filereadable(s:winrc)
"         exe 'so' s:winrc
"     endif
" endif
```

### Expanding environment variables

Nov 21, 2018

So I've noticed this in the docs more than a few times. But i just ran into this
horrible problem again. `g:python3_host_prog` wasn't setting and I wasn't sure
if it was because of the recent name change or what.

The logic in my python executable section is really weird now but
Vimscript is so fucking finnicky that what I did there was the only way i
could get it consistently working.

I changed `if executable(path)` to `if exists(':python3')` because
`echo executable('$PREFIX/bin/python')` was coming up 0. I couldn't figure out
why. So I used the colon to test if its a command that can be run on the ex
line.

Then I remembered. You have to run expand() on all env vars!!! The problems now
fixed and all is well. I just realized that that's an important case to need to
know how to handle so I figured I'd mark it.

## Plugins
------------

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

### NERDTree

Nothing happens if we open a directory to start nvim
Or specifically netrw opens.
TODO: one of the expressions in the loop needs to be prepended with silent
