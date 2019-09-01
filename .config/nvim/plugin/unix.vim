" ============================================================================
    " File: unix.vim
    " Author: Faris Chugthai
    " Description: Add GNU/Linux commands, functions and mappings
    " Last Modified: Jul 13, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_unix_vim') || &compatible || v:version < 700
  finish
endif
let g:did_unix_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" These should probably just get autoloaded. Why define them at startup?

" Options: {{{1

if has('unix')
  call unix_options#UnixOptions()

" Hey why not use the free if then?
else
  runtime autoload/msdos.vim
endif

" Tmux: {{{1

" Doesn't work. Fuck the way Vim namespaces shit holy hell.
" call <SID>unix#tmux_map('<leader>tt', '')
" call <SID>unix#tmux_map('<leader>th', '.left')
" call <SID>unix#tmux_map('<leader>tj', '.bottom')
" call <SID>unix#tmux_map('<leader>tk', '.top')
" call <SID>unix#tmux_map('<leader>tl', '.right')
" call <SID>unix#tmux_map('<leader>ty', '.top-left')
" call <SID>unix#tmux_map('<leader>to', '.top-right')
" call <SID>unix#tmux_map('<leader>tn', '.bottom-left')
" call <SID>unix#tmux_map('<leader>t.', '.bottom-right')

" Alternative Edit Implementation: {{{1
" Completes filenames from the directories specified in the 'path' option:
command! -nargs=1 -bang -complete=customlist,unix#EditFileComplete
   	\ EF edit<bang> <args>


" Chmod: {{{1
"	:S	Escape special characters for use with a shell command (see
"		|shellescape()|). Must be the last one. Examples:
"           :!dir <cfile>:S
"           :call system('chmod +w -- ' . expand('%:S'))
" From :he filename-modifiers in the cmdline page.
command! -nargs=1 -complete=file Chmod call system('chmod +x ' . expand('%:S'))

" More From The Bottom Of :he map.txt: {{{1

command! -nargs=+ -complete=file MyEdit
    \ for f in expand(<q-args>, 0, 1) |
    \ exe '<mods> split ' . f |
    \ endfor

command! -nargs=+ -complete=file Sedit call unix#SpecialEdit(<q-args>, <q-mods>)

" Mkdir: {{{1
" todo:

" Pure Emacs: {{{1
" There are more comfortable ways of doing the following in Vim.
" I'm not going to convince you it's better. That it's cleaner.
" Unfortunately, there are  few of *their* keybindings wired in.
" May as well map them correctly.

" Alt X: {{{2
" This seemingly trivial difference determines whether the following is run
" by fzf or the vim built-in, and they both have quite different looking
" interfaces IMO.
if exists('*fzf#wrap')
  noremap <M-x>      <Cmd>Commands<CR>
  noremap <C-x><C-b> <Cmd>Buffers<CR>
else
  noremap <M-x>      <Cmd>commands<CR>
  noremap <C-x><C-b> <Cmd>buffers<CR>
endif

noremap <silent> <C-x>o <Cmd>wincmd W<CR>

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
