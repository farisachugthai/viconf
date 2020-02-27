" ============================================================================
    " File: tmuxline.vim
    " Author: Faris Chugthai
    " Description: Tmuxline conf
    " Last Modified: April 02, 2019
" ============================================================================

scriptencoding utf-8
if !exists('$TMUX') | finish | endif
if !exists('g:plugs') | finish | endif

" Tmuxline Presets: {{{
let g:tmuxline_powerline_separators = 0

" if !has('unix')  " Wait did i ever check if this works? Does WSL show !has('unix') wth?
"   let g:tmuxline_preset = {
"       \'a'       : '#S', \'b'       : '#W',
"       \'c'       : '#H',
"       \'win'     : '#I #W',
"       \'cwin'    : '#I #W',
"       \'x'       : '%a',
"       \'y'       : '#W %R',
"       \'z'       : '#H',
"       \'options' : {'status-justify' : 'center'}}
" else
let g:tmuxline_status_justify = 'centre'
let g:tmuxline_powerline_separators = 1
let g:tmuxline_preset = {
      \ 'a'    : ['#[fg=#504945,bg=#dfbf8e] ▶ #S'],
      \ 'win'  : ['#I', '#W'],
      \ 'cwin' : ['#I', '#W'],
      \ 'y'    : ['#(uptime  | cut -d " " -f 1,2,3)'],
      \ 'z'    : ['#(whoami)', '#H'],
      \ 'options': {'status-justify' : 'centre' }}
" endif
" }}}

" Tmuxline Theme: {{{
" After defining all of these groups and format blocks, let's
" define the tmux line to match our vim statusline
let s:tmuxline_themes = stdpath('data') . '/plugged/tmuxline.vim/autoload/themes'

if filereadable(s:tmuxline_themes . '/vim_statusline_3.vim')
  execute 'source ' . s:tmuxline_themes . '/vim_statusline_3.vim'
  let g:tmuxline_theme = 'vim_statusline_3'
endif

let g:tmuxline_separators = {
     \ 'left' : '»',
     \ 'left_alt': '▶',
     \ 'right' : '«',
     \ 'right_alt' : '◀',
     \ 'space' : ' '}

" }}}

