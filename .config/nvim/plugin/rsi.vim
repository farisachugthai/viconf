
" RSI: {{{1
" start of line
cnoremap <C-A> <Home>
" back one character
cnoremap <C-B> <Left>
" delete character under cursor
cnoremap <C-D> <Del>
" end of line
cnoremap <C-E> <End>
" forward one character
cnoremap <C-F> <Right>
" recall newer command in history
cnoremap <A-N> <Down>
" recall previous command in command-line browser
cnoremap <A-P> <Up>
" back one word
cnoremap <A-B> <S-Left>
" forward one word
cnoremap <A-F> <S-Right>
" But still need the functionality
cnoremap <C-g> <Esc>
" Its annoying everything goes away from this typo
" Alternartively, how do you open the command window from ex mode?
cmap <nop> <Esc>
" top of buffer
cnoremap <A\<> :norm gg
" bottom of buffer
cnoremap <A\>> :norm G
