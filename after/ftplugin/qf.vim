" ============================================================================
  " File: qf.vim
  " Author: Faris Chugthai
  " Description: Quickfix mods
  " Last Modified: October 26, 2019
" ============================================================================

nnoremap <buffer> <Left> <Cmd>colder<CR>
nnoremap <buffer> <Right> <Cmd>cnewer<CR>

" These need to catch E776 no location list
nnoremap <buffer><silent> <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>

nnoremap <buffer><silent> <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

if !get(g:, 'qf_disable_statusline')
  let b:undo_ftplugin = "setlocal stl<"

  " Display the command that produced the list in the quickfix window:
endif

setlocal stl=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P

if !exists('g:loaded_qf') | finish | endif

let g:qf_mapping_ack_style = 1

nnoremap <buffer> { <Plug>(qf_previous_file)
nnoremap <buffer> } <Plug>(qf_next_file)
