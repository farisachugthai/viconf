" ============================================================================
  " File: json.vim
  " Author: Faris Chugthai
  " Description: JSON ftplugin
  " Last Modified: Oct 20, 2019
" ============================================================================

" Got this from the syntax file
let g:vim_json_warnings = 1
" Always set the globals first

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

" dont use theirs its damn near empty
" source $VIMRUNTIME/ftplugin/json.vim
source $VIMRUNTIME/indent/json.vim

syntax match jsonComment +\/\/.\+$+

highlight! link jsonComment Comment

setlocal formatoptions-=t

" The original ftplugin states that JSON has no comments.
" Well sometimes it does fuck you
let &commentstring='// %s'
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

setlocal conceallevel=2
setlocal concealcursor=nvc

" Let's add in a few more options though. Enforce 2 space tabs
setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
setlocal suffixesadd=.json,.js,.jsx,.ts,tsx
setlocal foldmethod=syntax
setlocal shiftround

let b:undo_ftplugin = 'setlocal fo< com< cms< cocu< cole<'
      \. '|setlocal matchpairs< et< sts< sw< ts< sua< fdm< sr< '

" Set up ALE correctly
call ftplugins#ALE_JSON_Conf()

" These mappings are particularly nice in JSON files.:
inoremap <buffer> ( ()<C-G>U<Left>
inoremap <buffer> [ []<C-G>U<Left>
inoremap <buffer> { {}<C-G>U<Left>
inoremap <buffer> " ""<C-G>U<Left>
" Also can we auto fix single quotes? use C-r' if you need to use a literal single quote...
" honestly that never happens though.
inoremap <buffer> ' "<C-G>U<Left>

setlocal matchpairs+=::,"",

if exists('loaded_matchit')
  " Set up matchit:
  let b:match_ignorecase = 1
  let b:match_words = '<:>,{:},"",(:),[:]'

  let b:undo_ftplugin .= '|unlet! b:match_ignorecase'
        \ . '|unlet! b:match_words'

endif

" And set up a formatter.
" For more see ../python3/_vim
command! -buffer -bang -range Pjson :w<bang><bar><line1>,<line2>python3 import _vim; _vim.pretty_it('json')


let b:undo_ftplugin .= '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
      \ . '|unlet! b:undo_indent'
      \ . '|unlet! b:did_indent'
      \ . '|unlet! b:ale_fixers'
      \ . '|unlet! b:ale_linters'
      \ . '|unlet! b:ale_linters_explicit'
      \ . '|silent! iunmap <buffer> ('
      \ . '|silent! iunmap <buffer> ['
      \ . '|silent! iunmap <buffer> {'
      \ . '|silent! iunmap <buffer> "'
      \ . "|silent! iunmap <buffer> '"
      \ . '|silent! delcom Pjson'

