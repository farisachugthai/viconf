" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax commands
    " Last Modified: Jul 15, 2019
" ============================================================================
"
" Guards: {{{1

if exists('g:did_autoload_syncom_vim') || &compatible || v:version < 700
    finish
endif
let g:did_autoload_syncom_vim = 1

let s:cpo_save = &cpoptions
set cpoptions-=c

" Syntax Highlighting Functions: {{{1

" HL: Whats the highlighting group under my cursor? {{{1
function! syncom#HL() abort

  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')

endfunction


" HiC: Show hl group and fg color {{{1
function! syncom#HiC() abort
  " This function could be expanded with groups 
  echo 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
  echo 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')

endfunction


" HiDebug: {{{1

function! syncom#HiD() abort

  " TODO: Debug
  echo join(map(synstack(line('.'), col('.')),) synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')

endfunction

" HiAll: Now utilize quickfix {{{1

function! syncom#HiQF() abort

  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

endfunction

" SyntaxInfo: {{{1
function! g:syncom#get_syn_id(transparent) abort

  " Display syntax infomation on under the current cursor
  let synid = synID(line('.'), col('.'), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif

endfunction

function! g:syncom#get_syn_attr(synid) abort

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

function! g:syncom#get_syn_info() abort

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

" Hitest: An easier way of sourcing hitest {{{1

function! g:syncom#hitest() abort

  try
    so $VIMRUNTIME/syntax/hitest.vim
  catch E403
  endtry

endfunction

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
