" ============================================================================
    " File: pydoc.vim
    " Author: Faris Chugthai
    " Description: " pydoc.vim: pydoc integration for vim
    " Last Modified: April 08, 2019
" ============================================================================

" Doc: {{{1
" So I found this somewhere and wanted to throw it back into the repository if
" you get bored.
"
" We could define an external command using
" let g:pydoc_cmd etc etc
"
" Or you could define a function such that a remote host can utilize it.
" Then we don't block anything while looking through the docs.
" It'd make really large greps on pydocs a lot easier. It'd also make it
" faster if we integrated FZF into the mix and used  the output from this
" command as the sink to one of it's autoload functions.
" Alternatively though, you could just utilize jedi more effectively and have
" it set to set its mappings in py/rst/maybe rst.txt files.
" Then just get more comfortable with th go to usages and declarations.

" HOWEVER. Continue downwards for more of my thoughts.

"This plugin integrates the pydoc into vim. You can view the
"documentation of a module by using :Pydoc foo.bar.baz or search
"a word (uses pydoc -k) in the documentation by typing PydocSearch
"foobar. You can also view the documentation of the word under the
"cursor by pressing <leader>pw or the WORD (see :help WORD) by pressing
"<leader>pW.
"This is very useful if you want to jump to a module which was found by
"PydocSearch. To have a browser like feeling you can use u and CTRL-R to
"go back and forward, just like editing normal text.

"If you want to use the script and pydoc is not in your PATH, just put a
"line like

" let g:pydoc_cmd = \"/usr/bin/pydoc" (without the backslash!!)

"in your .vimrc

" If you want to open pydoc files in vertical splits or tabs, give the
" appropriate command in your .vimrc with:
"
" let g:pydoc_open_cmd = 'vsplit'
"
" or
"
" let g:pydoc_open_cmd = 'tabnew'
"
" The script will highlight the search term by default. To disable this behaviour
" put in your .vimrc:
"
" let g:pydoc_highlight=0
"
" If you want pydoc to switch to an already open tab with pydoc page,
" set this variable in your .vimrc (uses drop - requires vim compiled with
" gui!):
"
" let g:pydoc_use_drop=1
"
" Pydoc files are open with 10 lines height, if you want to change this value
" put this in your .vimrc:
"
" let g:pydoc_window_lines=15
" or
" let g:pydoc_window_lines=0.5
"
" Float values specify a percentage of the current window.
"
"
"pydoc.vim is free software, you can redistribute or modify
"it under the terms of the GNU General Public License Version 2 or any
"later Version (see http://www.gnu.org/copyleft/gpl.html for details).

"Please feel free to contact me.

" Options: {{{1
if !exists('g:pydoc_perform_mappings')
    let g:pydoc_perform_mappings = 1
endif

if !exists('g:pydoc_highlight')
    let g:pydoc_highlight = 1
endif

if !exists('g:pydoc_cmd')
    let g:pydoc_cmd = 'pydoc'
endif

if !exists('g:pydoc_open_cmd')
    let g:pydoc_open_cmd = 'split'
endif

" Functions: {{{1

" ShowPyDoc: {{{2
    " Needs to be a way better check for 'if we're already in the manpager...
    " if bufloaded('__doc__') >0
        " let l:buf_is_new = 0
    " else
        " let l:buf_is_new = 1
    " endif

    " Stop using sb and abbreviations.
    " if bufnr('__doc__') >0
        " execute 'sb __doc__'
    " else
        " execute 'split __doc__'
    " endif

    " setlocal noswapfile

    " Forgot the local or does it not work that way?
    " You totally can. Also why nofile???
    " setlocal buftype=help
    " why the fuck would you set modifiable??
    " setlocal nomodifiable

    " only saving the below so you can remember that we got halfway through the function
    " before we decided 'fuck it wipe the buffer'
    " normal ggdG
    " OHHHH I just got it. This first part is to check if we're in a pydoc help page already!
    " If so we need to set modifiable and the others
    " The purpose of the above section and below section are quite different.
    " Break this into AT LEAST two functions from here.

function! s:GetWindowLine(value)  " {{{2
    if a:value < 1
        return float2nr(winheight(0)*a:value)
    else
        return a:value
    endif
endfunction


function! ShowPyDoc(name, type)  " {{{2
" Args: name: lookup; type: 0: search, 1: lookup

    if a:name ==# ''
        return
    endif

    let s:name2 = substitute(a:name, '(.*', '', 'g' )
    let s:name2 = substitute(a:name, ':', '', 'g' )

    " type==1 when type is str
    if a:type==1
        execute  'silent read ! ' . g:pydoc_cmd . ' ' . s:name2
    else
        execute  'silent read ! ' . g:pydoc_cmd . ' -k ' . s:name2
    endif
    " setlocal nomodified
    set filetype=man
    normal 1G
    " could we do `call nvim_set_current_line()`

    " ...used to be pydoc_wh...
    if !exists('g:pydoc_win_height')
        let g:pydoc_win_height = 10
    end
    resize -999
    execute 'silent resize +' . g:pydoc_win_height

    " was pydoc_highlight...
    if !exists('g:pydoc_hl_disable')
        let g:pydoc_hl_disable = 1
        call Highlight(s:name2)
    endif

    let l:line = getline(2)
    if l:line =~? '^no Python documentation found for.*$'
        if l:buf_is_new
            execute 'bd!'
        else
            normal u
        endif
        redraw
        echohl WarningMsg | echo l:line | echohl None
    endif
endfunction

" Highlight: {{{2

function! Highlight(name)
    execute 'sb __doc__'
    set filetype=man
    syn on
    execute 'syntax keyword pydoc '.s:name2
    hi pydoc gui=reverse
endfunction

" Should have a setting to disable all mappings
" In addition plugins conventionally should use localleader not leader

" Mappings: {{{1
" TODO: Should probably do a if !has_map() check first right?

augroup pydoc_mappings
    au FileType python,man map <buffer> <leader>pw :call ShowPyDoc('<C-R><C-W>', 1)<CR>
    au FileType python,man map <buffer> <leader>pW :call ShowPyDoc('<C-R><C-A>', 1)<CR>
    au FileType python,man map <buffer> <leader>pk :call ShowPyDoc('<C-R><C-W>', 0)<CR>
    au FileType python,man map <buffer> <leader>pK :call ShowPyDoc('<C-R><C-A>', 0)<CR>
augroup end

" Commands: {{{1

" TODO: Definitely needs a -complete arg
command! -nargs=1  Pydoc :call ShowPyDoc('<f-args>', 1)

" Whoops. This command doesn't work anymore.
command! -nargs=*  PydocSearch :call ShowPyDoc('<f-args>', 0)

" These commands doe. We coudl grep them, fzf them, aggregate them. There's a whole lot
" of fun to be had here
