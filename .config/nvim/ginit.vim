" header

" We need to distinguish between other gui programs and this one
if !has('nvim')
  finish
endif

runtime nvim_gui_shim

if empty(':GuiTabline')
  echoerr 'Messed up the ginit guard'
  finish
endif

" Also don't load this multiple times

" Holy hell we get the tabline back!!!
GuiTabline v:false

GuiLinespace 1

GuiFont Hack

call GuiClipboard()
