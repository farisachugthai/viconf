" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax commands
    " Last Modified: April 08, 2019
" ============================================================================

if exists('g:did_autoload_syncom_vim') || &cp || v:version < 700
    finish
endif
let g:did_autoload_syncom_vim = 1

" Syntax Highlighting Functions: {{{1

" HL: Whats the highlighting group under my cursor? {{{1
function! syncom#HL()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction


" HiC: Show hl group and fg color {{{1

" Heres a possibly easier way to do this. Still in testing.
" Mar 17, 2019: So far behaves as expected!
function! syncom#HiC()
    echo 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
    echo 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')
endfunction


" HiDebug: {{{1
" function! s:HiD()
"     echo join(map(synstack(line('.'), col('.')), 'synIDattr(id, "name")') '\n')
" endfunction

" command! HiD call <SID>HiD()

" HiAll: Now utilize quickfix {{{1
function! syncom#HiQF()
  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" SyntaxInfo: {{{1
" Display syntax infomation on under the current cursor
function! g:syncom#get_syn_id(transparent)
  let synid = synID(line('.'), col('.'), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! g:syncom#get_syn_attr(synid)
  let name = synIDattr(a:synid, 'name')
  let ctermfg = synIDattr(a:synid, 'fg', 'cterm')
  let ctermbg = synIDattr(a:synid, 'bg', 'cterm')
  let guifg = synIDattr(a:synid, 'fg', 'gui')
  let guibg = synIDattr(a:synid, 'bg', 'gui')
  return {
        \ 'name': name,
        \ 'ctermfg': ctermfg,
        \ 'ctermbg': ctermbg,
        \ 'guifg': guifg,
        \ 'guibg': guibg}
endfunction

function! g:syncom#get_syn_info()
  let baseSyn = g:get_syn_attr(g:get_syn_id(0))
  echo 'name: ' . baseSyn.name .
        \ ' CTERMFG: ' . baseSyn.ctermfg .
        \ ' ctermbg: ' . baseSyn.ctermbg .
        \ ' guifg: ' . baseSyn.guifg .
        \ ' guibg: ' . baseSyn.guibg
  let linkedSyn = g:get_syn_attr(g:get_syn_id(1))
  echo 'link to'
  echo 'name: ' . linkedSyn.name .
        \ ' ctermfg: ' . linkedSyn.ctermfg .
        \ ' ctermbg: ' . linkedSyn.ctermbg .
        \ ' guifg: ' . linkedSyn.guifg .
        \ ' guibg: ' . linkedSyn.guibg
endfunction