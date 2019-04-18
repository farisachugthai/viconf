" ============================================================================
    " File: finger.vim
    " Author: Faris Chugthai
    " Description: A description of the file below
    " Last Modified: April 17, 2019
" ============================================================================

" Finger: {{{1
" Example from :he command-complete
" The following example lists user names to a Finger command
command! -complete=custom,ListUsers -nargs=1 Finger !finger <args>

function! finger#ListUsers(A,L,P)
    return system('cut -d: -f1 /etc/passwd')
endfun

" Completes filenames from the directories specified in the 'path' option:
command! -nargs=1 -bang -complete=customlist,finger#EditFileComplete
   	\ EF edit<bang> <args>

function! finger#EditFileComplete(A,L,P)
    return split(globpath(&path, a:A), '\n')
endfunction

" This example does not work for file names with spaces!
