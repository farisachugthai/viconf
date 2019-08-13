" ============================================================================
  " File: man.vim
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with help buffers
  " Last Modified: July 23, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

" Pydoc Cword: {{{1
function! pydoc_help#PydocCword() abort

  " Holy shit it works!!!
  let s:temp_cword = expand('<cWORD>')
  enew
  exec ':r! pydoc ' . s:temp_cword
  setlocal relativenumber
  setlocal filetype=rst
  setlocal nomodified
  setlocal buflisted
  silent setlocal nomodifiable

  " If you wanna keep going we can change the status line. We can change how
  " we invoke python
endfunction

" Pydoc Split Cword: {{{1
function! pydoc_help#SplitPydocCword() abort
  let s:temp_cword = expand('<cWORD>')
  split
  enew
  exec ':r! pydoc ' . s:temp_cword
  setlocal relativenumber
  setlocal filetype=rst
  setlocal nomodified
  setlocal buflisted
  silent setlocal nomodifiable
endfunction

" Pydoc Arg: {{{1

function! pydoc_help#Pydoc(module) abort

  " Look at me handling user configured arguments!
  if exists('g:pydoc_window')
    if type('g:pydoc_window') == v:t_string
      exec g:pydoc_window
    else
      throw '/autoload/pydoc_help:'
            \ . ' g:pydoc_window needs to be one of "split" "vsplit" or "tabe"'
    endif
  else
    split
  endif

  enew
  exec ':r! pydoc ' . a:module
  setlocal relativenumber
  setlocal filetype=rst
  setlocal buflisted
  setlocal nomodified

  " If you wanna keep going we can change the status line. We can change how
  " we invoke python
endfunction

" Helptags: {{{1

function! pydoc_help#Helptab() abort
  setlocal number relativenumber
  if len(nvim_list_wins()) > 1
    wincmd T
  endif

  setlocal nomodified
  setlocal buflisted
  " Complains that we can't modify any buffer. But its a local option so yes we can
  silent setlocal nomodifiable

endfunction

" Async Pydoc: {{{1

" Dude this actually works
function! pydoc_help#async_cursor() abort

  call jobstart('pydoc ' . expand('<cWORD>'), {'on_stdout':{j,d,e->append(line('.'),d)}})
endfunction

function! pydoc_help#scratch_buffer() abort  " {{{1
 
  " From he api-floatwin. Only new versions of Nvim (maybe 0.4+ only?)
  let buf = nvim_create_buf(v:false, v:true)

  " original: should fill with pydoc output
  " call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
  let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
      \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
  let win = nvim_open_win(buf, 0, opts)
  " optional: change highlight, otherwise Pmenu is used
  " call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

  " To close the float, |nvim_win_close()| can be used.
endfunction


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
