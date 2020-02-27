" ============================================================================
    " File: syncom.vim
    " Author: Faris Chugthai
    " Description: Syntax commands
    " Last Modified: Nov 13, 2019
" ============================================================================

function! syncom#HL() abort  " HL: Whats the highlighting group under my cursor? {{{

  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')

endfunction  " }}}

function! syncom#HiC() abort  " HiC: Show hl group and fg color {{{
  " This function could be expanded by expanding the hl groups
  echomsg 'Highlighting group: ' . synIDattr(synID(line('.'), col('.'), 1), 'name')
  echomsg 'Foreground color: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg')
endfunction   " }}}

function! syncom#HiD() abort  " HiDebug: {{{

  " TODO: Debug. The parenthesis got fucked up at some point so figure that out
  echo join(map(synstack(line('.'), col('.')), synIDattr(synIDtrans(synID(line('.'), col('.'), 1)))), 'fg')

endfunction  " }}}

function! syncom#HiQF() abort  " HiAll: Now utilize quickfix {{{
  " synstack returns a list. takes lnum and col.
  " map is crazy specific in its argument requirements. map(list, string)
  " cexpr evals a command and adds it to the quickfist list
  cexpr! map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction   " }}}

function! syncom#get_syn_id(...) abort  " {{{
  " Display syntax infomation on under the current cursor
  let synid = synID(line('.'), col('.'), 1)
  " Wait are arguments allowed to be optional
  if a:0 == 0
    return synid
  else
    return synIDtrans(synid)
  endif
endfunction  " }}}

function! syncom#get_syn_attr(synid) abort  " {{{
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
endfunction  " }}}

function! syncom#get_syn_info() abort  " {{{
  let baseSyn = syncom#get_syn_attr(synID(line("."), col("."), 1))
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
endfunction  " }}}

function! syncom#hitest() abort  " Hitest: An easier way of sourcing hitest {{{
  try
    source $VIMRUNTIME/syntax/hitest.vim
  catch E403
  endtry
  return v:true
endfunction  " }}}

function! s:rg_setup() abort  " {{{

  if executable('rg')
    let s:cmd = 'rg'
  elseif executable('rg.exe')
    let s:cmd = 'rg.exe'
  else
    return v:false
  endif
" -M, --max-columns <NUM>                 Don't print lines longer than this limit.
" --max-columns-preview               Print a preview for lines exceeding the limit.
" -m, --max-count <NUM>                   Limit the number of matches.
" --max-depth <NUM>                   Descend at most NUM directories.
" --max-filesize <NUM+SUFFIX?>        Ignore files larger than NUM in size.
" Dude I thought vimgrep implies colors never wtf
  let s:options = ' --vimgrep --smart-case --hidden --color never'
        \ . ' --max-columns 300 --max-count 5 --max-columns-preview --max-depth 10 --max-filesize 5000'
        \ . ' --ignore-file-case-insensitive --glob-case-insensitive'
        \ . ' --no-heading --trim --with-filename --no-line-number --context 0'
  if !has('unix')
    let s:options .= ' --crlf'
  endif

  let s:grep = s:cmd . s:options
  let &g:grepprg = s:grep
  return s:grep

endfunction  " }}}

function! s:fd_setup() abort  " {{{

  if executable('fd')
    let s:cmd = 'fd'
  elseif executable('fd.exe')
    let s:cmd = 'fd.exe'
  else
    throw 'syncom#grepprg: Neither fd nor rg are executable. Set grepprg to grep or something I guess.'
  endif
  let s:options = ' -H '
  let g:grep = s:cmd . s:options
  let &g:grepprg = g:grep
  return g:grep
endfunction  " }}}

function! syncom#grepprg(...) abort  " {{{
  " executable check was in ../plugin/syncom.vim but we haven't figured out
  " if we're using rg.exe or rg.exe
  "
  " rg's been giving me a ton of problems on windows and even on linux i never
  " had it set up the way i wanted. i'm realizing fd is probably moreso what i
  " want
  let s:ret = s:rg_setup()
  if s:ret == v:false
    let s:ret = s:fd_setup()
  endif
  return s:ret
endfunction  " }}}

function! syncom#gruvbox() abort  " {{{ old colorscheme
  if empty(globpath(&runtimepath, 'colors/gruvbox.vim'))
    return v:false
  else
    let g:gruvbox_contrast_hard = 1
    let g:gruvbox_contrast_soft = 0
    let g:gruvbox_improved_strings = 1
    let g:gruvbox_italic = 1
    colorscheme gruvbox
    return v:true
  endif
endfunction  " }}}

function! syncom#gruvbox_material() abort  " {{{ new colorscheme
  " TODO:
  if empty(globpath(&runtimepath, 'colors/gruvbox-material.vim'))
    return v:false
  else
    let g:gruvbox_material_transparent_background = 1
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_background = 'hard'
    colo gruvbox-material
    return v:true
  endif
endfunction  " }}}

function! syncom#rainbow_paren() abort  " {{{
  highlight! link RBP1 Red
  highlight! link RBP2 Yellow
  highlight! link RBP3 Green
  highlight! link RBP4 Blue
  let g:rainbow_levels = 4
  function! RainbowParens(cmdline)
    let ret = []
    let i = 0
    let lvl = 0
    while i < len(a:cmdline)
      if a:cmdline[i] is# '('
        call add(ret, [i, i + 1, 'RBP' . ((lvl % g:rainbow_levels) + 1)])
        let lvl += 1
      elseif a:cmdline[i] is# ')'
        let lvl -= 1
        call add(ret, [i, i + 1, 'RBP' . ((lvl % g:rainbow_levels) + 1)])
      endif
      let i += 1
    endwhile
    return ret
  endfunction
  call input({'prompt':'>','highlight':'RainbowParens'})

  " From he input
endfunction  " }}}
