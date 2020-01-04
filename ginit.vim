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

" GuiFonts: Note that you can't quote! Use backslashes

" Also note adding in the :h thing consistently causes an error
" to get thrown for "bad pitch metrics"

" works but 'reports bad fixed font pitch metrics'
" GuiFont FuraMono\ Nerd\ Font\ Mono
" works but meh
" GuiFont Hack:h11
" Throws an error because not fixed pitch
" GuiFont Monoisome:h11
" Also note that when you go to `:he guifont`
" the info for set guifont isn't true of our command here
" holy fuck this does work
" holy fuck this one actually looks good.
" GuiFont DejaVu\ Sans\ Mono:h11
" why is it throwing errors now
" GuiFont Cascadia\ Code
GuiFont Fira\ Code\ Retina:h12

call GuiClipboard()

" We need to map something to GuiTreeviewToggle!
nnoremap <Leader>? <Cmd>GuiTreeviewToggle<CR><bar>execute 'echomsg ' . 'Opening up Nvim_Explorer.exe'
