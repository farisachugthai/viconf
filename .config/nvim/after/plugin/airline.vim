" ============================================================================
    " File: airline.vim
    " Author: Faris Chugthai
    " Description:
    " Last Modified: January 13, 2019
" ============================================================================

if exists('did_airline_vim') || &cp || v:version < 700
    finish
endif
let did_airline_vim = 1

" Mappings: {{{1
let g:airline#extensions#tabline#buffer_idx_mode = 1
" originally was nmap and that mightve been better. markdown
" headers would be perfect for leader 1
nnoremap <Leader>1 <Plug>AirlineSelectTab1
nnoremap <Leader>2 <Plug>AirlineSelectTab2
nnoremap <Leader>3 <Plug>AirlineSelectTab3
nnoremap <Leader>4 <Plug>AirlineSelectTab4
nnoremap <Leader>5 <Plug>AirlineSelectTab5
nnoremap <Leader>6 <Plug>AirlineSelectTab6
nnoremap <Leader>7 <Plug>AirlineSelectTab7
nnoremap <Leader>8 <Plug>AirlineSelectTab8
nnoremap <Leader>9 <Plug>AirlineSelectTab9
nnoremap <Leader>- <Plug>AirlineSelectPrevTab
nnoremap <Leader>+ <Plug>AirlineSelectNextTab

" Options: {{{1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_skip_empty_sections = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Unicode_Symbols: {{{2
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" Extensions: {{{1
" TODO: Need to add one for the venv nvim
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#csv#enabled = 0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#tabline#tab_nr_type = 1 " splits and tab number
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#fnametruncate = 1
let g:airline#extensions#ale#enabled = 1

" Vim: set foldlevel=0:
