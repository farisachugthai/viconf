" ============================================================================
  " File: ginit.vim
  " Author: Faris Chugthai
  " Description: Gui nvim initialization
  " Last Modified: September 09, 2019
" ============================================================================

" Guard: {{{1
" Same way it's implemented in nvim_gui_shim. OH but don't forget.
" ONLY LOAD if g:GuiLoaded exists. Probably not being reread
if !has('nvim') || !exists('g:GuiLoaded')
  finish
endif

" But let's set something up in case it does get reread
if exists('g:did_ginit_vim') || &compatible || v:version < 700
  finish
endif
let g:did_ginit_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
runtime plugin/nvim_gui_shim.vim

" Holy hell we get the tabline back!!!
GuiTabline v:false

" This looks reasonable with the font
GuiLinespace 1.5

" Doesn't work
" GuiFont 'FuraMono Nerd Font Mono:h14'
GuiFont Hack:h11

call GuiClipboard()

" We need to map something to GuiTreeviewToggle!
noremap <Leader>? <Cmd>GuiTreeviewToggle<CR><bar>execute 'echomsg ' . 'Opening up Nvim_Explorer.exe'


" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
