" ============================================================================
  " File: ginit.vim
  " Author: Faris Chugthai
  " Description: Gui nvim initialization
  " Last Modified: September 09, 2019
" ============================================================================

" Same way it's implemented in nvim_gui_shim. OH but don't forget.
" ONLY LOAD if g:GuiLoaded exists. Probably not being reread
if !has('nvim') || !exists('g:GuiLoaded')
  finish
endif

runtime plugin/nvim_gui_shim.vim

" Holy hell we get the tabline back!!!
GuiTabline v:false

" This looks reasonable with the font
GuiLinespace 1

" Doesn't work
" GuiFont 'FuraMono Nerd Font Mono:h14'
" can't quote
" works but meh
" GuiFont Hack:h11
" Throws an error because not fixed pitch
" GuiFont Monoisome:h11
" the info for set guifont isn't true of our command here
" GuiFont FuraMono_Nerd_Font_Mono:h12
" doesn't work

" holy fuck this does work
" GuiFont FuraMono\ Nerd\ Font\ Mono:h12
" holy fuck this one actually looks good.
GuiFont DejaVu\ Sans\ Mono:h11

call GuiClipboard()

" We need to map something to GuiTreeviewToggle!
nnoremap <Leader>? <Cmd>GuiTreeviewToggle<CR><bar>execute 'echomsg ' . 'Opening up Nvim_Explorer.exe'
