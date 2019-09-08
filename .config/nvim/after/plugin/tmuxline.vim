" ============================================================================
    " File: tmuxline.vim
    " Author: Faris Chugthai
    " Description: Tmuxline conf
    " Last Modified: April 02, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'tmuxline.vim')
    finish
endif

if exists('g:did_tmuxline_conf') || &compatible || v:version < 700
    finish
endif
let g:did_tmuxline_conf = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Tmuxline Presets: {{{1
let g:tmuxline_powerline_separators = 0

if !has('unix')
  let g:tmuxline_preset = {
      \'a'       : '#S',
      \'b'       : '#W',
      \'c'       : '#H',
      \'win'     : '#I #W',
      \'cwin'    : '#I #W',
      \'x'       : '%a',
      \'y'       : '#W %R',
      \'z'       : '#H',
      \'options' : {'status-justify' : 'left'}}
else
 let g:tmuxline_preset = {
       \'a'    : ['S:', '#S'],
       \'win'  : ['#I', '#W'],
       \'cwin' : ['#I', '#W'],
       \'y'    : ['#(uptime  | cut -d " " -f 1,2,3)'],
       \'z'    : ['#(whoami)', '#H'],
       \ 'options': {'status-justify' : 'left' }}
endif

" Tmuxline Theme: {{{1
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

" Autocmd On VimEnter: {{{1

" Doesn't work as you typically open to Startify where nomodifiable is set :/
" augroup Tmuxline
"   au!
"   autocmd VimEnter * <Cmd>Tmuxline vim_statusline_3<CR> 
" augroup END

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
