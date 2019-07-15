" " ============================================================================
    " File: format.vim
    " Author: Faris Chugthai
    " Description: Autoloaded formatter from :he format-formatexpr
    " Last Modified: February 24, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_format_vim') || &compatible || v:version < 700
  finish
endif
let g:did_format_vim = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Functions: {{{1

function! format#Format() abort
"                                                         *format-formatexpr*
" The 'formatexpr' option can be set to a Vim script function that performs
" reformatting of the buffer.  This should usually happen in an |ftplugin|,
" since formatting is highly dependent on the type of file.  It makes
" sense to use an |autoload| script, so the corresponding script is only loaded
" when actually needed and the script should be called <filetype>format.vim.

" For example, the XML filetype plugin distributed with Vim in the $VIMRUNTIME
" directory, sets the 'formatexpr' option to: >

"    setlocal formatexpr=xmlformat#Format()

" That means, you will find the corresponding script, defining the
" xmlformat#Format() function, in the directory:
" `$VIMRUNTIME/autoload/xmlformat.vim`

" Here is an example script that removes trailing whitespace from the selected
" text.  Put it in your autoload directory, e.g. ~/.vim/autoload/format.vim: >
" only reformat on explicit gq command
    if mode() !=# 'n'
        " fall back to Vims internal reformatting
        return 1
    endif
    let lines = getline(v:lnum, v:lnum + v:count - 1)
    call map(lines, {key, val -> substitute(val, '\s\+$', '', 'g')})
    call setline('.', lines)

    " do not run internal formatter!
    return 0
endfunc

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
