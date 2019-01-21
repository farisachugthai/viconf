" ============================================================================
	" File: rst.vim
	" Author: Faris Chugthai
	" Description: rst ftplugin
	" Last Modified: Jan 05, 2019
" ============================================================================
" The header snippet works phenomenally.

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4  " and expandtab is already set so that should set that
setlocal colorcolumn=80
setlocal linebreak

" riv!!! BTW adding <silent> doesn't mute errors if Tab isn't mapped
unmap <Tab>
let g:UltiSnipsExpandTrigger = '<Tab>'
inoremap <C-Tab> * <Esc>:call ultisnips#listsnippets()<CR>
