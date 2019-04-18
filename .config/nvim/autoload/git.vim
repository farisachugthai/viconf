" From git gutter.

" Cycle through hunks in all buffers
" ]c and [c jump from one hunk to the next in the current buffer. You can use this code to jump to the next hunk no matter which buffer it's in.

function! git#NextHunkAllBuffers()
  let line = line('.')
  GitGutterNextHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bnext
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! 1G
      GitGutterNextHunk
      return
    endif
  endwhile
endfunction

function! git#PrevHunkAllBuffers()
  let line = line('.')
  GitGutterPrevHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bprevious
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! G
      GitGutterPrevHunk
      return
    endif
  endwhile
endfunction

command! NextHunkAllBuffers call git#NextHunkAllBuffers()
command! PrevHunkAllBuffers call git#PrevHunkAllBuffers()

noremap <silent> ]c :call git#NextHunkAllBuffers()<CR>
noremap <silent> [c :call git#PrevHunkAllBuffers()<CR>
