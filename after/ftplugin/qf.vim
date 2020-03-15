" ============================================================================
  " File: qf.vim
  " Author: Faris Chugthai
  " Description: Quickfix mods
  " Last Modified: October 26, 2019
" ============================================================================

" if exists('b:loaded_qf_vim') || &compatible || v:version < 700
"     finish
" endif
" let b:loaded_qf_vim = 1
nnoremap <buffer> <Left> <Cmd>colder<CR>
nnoremap <buffer> <Right> <Cmd>cnewer<CR>

" These need to catch E776 no location list
nnoremap <buffer><silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>

nnoremap <buffer><silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

if !get(g:, 'qf_disable_statusline', 0)
  let b:undo_ftplugin = 'setlocal stl<'

  " Display the command that produced the list in the quickfix window:
endif

setlocal statusline=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P

if !exists('g:loaded_qf') | finish | endif

nnoremap <buffer> { <Plug>(qf_previous_file)
nnoremap <buffer> } <Plug>(qf_next_file)

" So this one is definitely a local mapping
nnoremap <buffer> <M-t> QfHistoryOlder

" This goes up an ddown the quickfix list so it's not labelled as a local
" mapping but it works that way
nnoremap <buffer> <M-p> <Plug>(qf_qf_previous)
nnoremap <buffer> <M-n> <Plug>(qf_qf_next)
