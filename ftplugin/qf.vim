" ============================================================================
  " File: qf.vim
  " Author: Faris Chugthai
  " Description: Quickfix mods
  " Last Modified: October 26, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

source $VIMRUNTIME/ftplugin/qf.vim

nnoremap <buffer> <Left> <Cmd>colder<CR>
nnoremap <buffer> <Right> <Cmd>cnewer<CR>

nnoremap <buffer> <Tab> <Cmd>cnext<CR>
nnoremap <buffer> <S-Tab> <Cmd>cNext<CR>

" These need to catch E776 no location list
nnoremap <buffer><silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>

nnoremap <buffer><silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

let b:undo_ftplugin .= '|setlocal modifiable< modified< syntax<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|silent! <buffer> nunmap <Tab>'
      \ . '|silent! <buffer> nunmap <S-Tab>'
      \ . '|silent! <buffer> nunmap <C-Down>'
      \ . '|silent! <buffer> nunmap <Left>'
      \ . '|silent! <buffer> nunmap <Right>'
      \ . '|silent! <buffer> nunmap <C-Up>'
      \ . '|au! * <buffer>'
" remove buffer-local autocommands for current buffer

if !exists('g:loaded_qf') | finish | endif
nnoremap <buffer> { <Plug>(qf_previous_file)
nnoremap <buffer> } <Plug>(qf_next_file)

" So this one is definitely a local mapping
nnoremap <buffer> <M-t> QfHistoryOlder

" This goes up an ddown the quickfix list so it's not labelled as a local
" mapping but it works that way
nnoremap <buffer> <M-p> <Plug>(qf_qf_previous)
nnoremap <buffer> <M-n> <Plug>(qf_qf_next)

let b:undo_ftplugin .= '|silent! <buffer> nunmap {'
      \ . '|silent! <buffer> nunmap }'
      \ . '|silent! <buffer> nunmap <M-t>'
      \ . '|silent! <buffer> nunmap <M-p>'
      \ . '|silent! <buffer> nunmap <M-n>'
