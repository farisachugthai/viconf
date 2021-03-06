" ============================================================================
  " File: ginit.vim
  " Author: Faris Chugthai
  " Description: Gui nvim initialization
  " Last Modified: September 09, 2019
" ============================================================================

" Guard: {{{

" Same way it's implemented in nvim_gui_shim. OH but don't forget.
" ONLY LOAD if g:GuiLoaded exists. Probably not being reread
if !has('nvim') || !exists('g:GuiLoaded')
  finish
endif
" }}}

runtime plugin/nvim_gui_shim.vim

" Holy hell we get the tabline back!!!
GuiTabline v:false

" This looks reasonable with the font
GuiLinespace 1

" GuiFonts: Note that you can't quote! Use backslashes {{{

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

" both work but wanted to switch it
" GuiFont Cascadia\ Code
" GuiFont Fira\ Code\ Retina:h12

" Not too bad
" GuiFont Monoid

" Doesn't work even though we can set the windows terminal font to this DX
" GuiFont Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Windows\ Compatible

" Glyphs and icons seem to work! Fires that bad metrics thing but honestly not even bad
GuiFont Droid\ Sans\ Mono
" }}}

command! -bar GuiName echo GuiName()
command! -complete=buffer -range=% -addr=loaded_buffers -bar -nargs=*  GuiDrop call GuiDrop(<f-args>)

" We need to map something to GuiTreeviewToggle!
nnoremap <Leader>ag <Cmd>GuiTreeviewToggle<CR>redraw!<CR>echomsg 'Opening up Nvim_Explorer.exe'<CR>

" Vim: set fdm=marker:
