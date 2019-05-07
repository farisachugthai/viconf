" Vim script to fix duplicate words in a .dic file
" Also works perfectly with wordlists
" Actually no it doesn't.
" vim: set ft=vim:
" Usage: Edit the .dic file and source this script.

function! s:fixdup() abort
  let s:DEBUG = v:true
  let s:deleted = 0

  " Start below the word count.
  let s:lnum = 2
  if s:DEBUG
    echomsg 's:lnum is: ' . s:lnum
  while s:lnum <= line('$')
    let s:word = getline(s:lnum)
    if s:word !~? '^$'
      if search('^' . s:word . '/', 'w') != 0
        let s:deleted += 1
        exe s:lnum . 'd'
        continue		" don't increment lnum, it's already at the next word
      endif
    endif
    if s:lnum%1000 == 0
      echon '\r Processing line ' . s:lnum . printf(' [ %02d%%]', s:lnum*100/line('$'))
    endif
    let s:lnum += 1
  endwhile

  if s:deleted == 0
    echomsg 'No duplicate words found'
  elseif s:deleted == 1
    echomsg 'Deleted 1 duplicate word'
  else
    echomsg printf('Deleted %d duplicate words', s:deleted)
  endif
endfunction

command! FixSpell call s:fixdup()

" In case you want to simply source the file
call s:fixdup()
