" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax commands
    " Last Modified: Nov 13, 2019
" ============================================================================
"
" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=c

function! syncom#HL() abort  " HL: Whats the highlighting group under my cursor? {{{1
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction

function! syncom#HiC() abort  " HiC: Show hl group and fg color {{{1
  " This function could be expanded by expanding the hl groups
  echomsg 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
  echomsg 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')

endfunction

function syncom#HiD() abort  " HiDebug: {{{1
  " TODO: Debug
  echo join(map(synstack(line('.'), col('.')),) synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')
endfunction


function syncom#HiQF() abort  " HiAll: Now utilize quickfix {{{1
  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! syncom#get_syn_id(transparent) abort  " {{{1
  " Display syntax infomation on under the current cursor
  let synid = synID(line('.'), col('.'), 1)
  " Wait are arguments allowed to be optional
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! syncom#get_syn_attr(synid) abort  " {{{1
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

function! syncom#get_syn_info() abort  " {{{1
  let baseSyn = syncom#get_syn_attr(g:get_syn_id(0))
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

function! syncom#hitest() abort  " Hitest: An easier way of sourcing hitest {{{1
  try  " or just use runtime???
    " so $VIMRUNTIME/syntax/hitest.vim
    runtime $VIMRUNTIME/syntax/hitest.vim
  catch E403
  endtry
  return v:true
endfunction

function! syncom#grepprg() abort  " {{{1
  " executable check was in ../plugin/syncom.vim but we haven't figured out
  " if we're using rg.exe or rg.exe
  if executable('rg')
    let s:rg = 'rg'
  elseif executable('rg.exe')
    let s:rg = 'rg.exe'
  else
    throw 'syncom#grepprg: Rg not executable but grepprg set to it.'
  endif

  " actually between this coc and fzf maybe i should make rg options global
  let s:rg_options = ' --vimgrep --no-messages --smart-case --no-messages --hidden --no-heading --max-columsn 300 --max-columns-preview --no-ignore-messages --trim ^'
  " Well Im not gonna do it now.

  let s:grep = s:rg . s:rg_options

  return s:grep
endfunction

function syncom#gruvbox() abort  " {{{1 old colorscheme
  if empty(globpath(&rtp, 'colors/gruvbox.vim'))
    return v:false
  else
    let g:gruvbox_contrast_hard = 1
    let g:gruvbox_contrast_soft = 0
    let g:gruvbox_improved_strings = 1
    let g:gruvbox_italic = 1
    colorscheme gruvbox
    return v:true
  endif
endfunction

function syncom#gruvbox_material() abort  " {{{1 new colorscheme
  " TODO:
  if empty(globpath(&rtp, 'colors/gruvbox-material.vim'))
    return v:false
  else
    let g:gruvbox_material_transparent_background = 1
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_background = 'hard'
    colo gruvbox-material
    return v:true
  endif
endfunction

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
