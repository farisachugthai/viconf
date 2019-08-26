" ============================================================================
    " File: rst.vim
    " Author: Faris Chugthai
    " Description: ReStructured Text ftplugin
    " Last Modified: May 19, 2019
" ============================================================================

" Guard: {{{1
if exists('b:did_ftplugin') || &compatible || v:version < 700
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1
setlocal expandtab

setlocal colorcolumn=80
setlocal linebreak
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal spell!

" This works beautifully!
setlocal keywordprg=pydoc

augroup RstCompiler
    autocmd Filetype rst 
                \ if executable('sphinx-build') |
                \ let &makeprg = 'sphinx-build -b html ' |
                \ endif
augroup END

command! -buffer Sphinx call pydoc_help#sphinx_build(<q-args>)
" The Official Ftplugin: {{{1

setlocal comments=fb:.. commentstring=..\ %s

" reStructuredText standard recommends that tabs be expanded to 8 spaces
" The choice of 3-space indentation is to provide slightly better support for
" directives (..) and ordered lists (1.), although it can cause problems for
" many other cases.
"
" More sophisticated indentation rules should be revisted in the future.

if !exists('g:rst_style') || g:rst_style != 0
    setlocal expandtab shiftwidth=3 softtabstop=3 tabstop=8
endif

if has('patch-7.3.867')  " Introduced the TextChanged event.
  setlocal foldmethod=expr
  setlocal foldexpr=RstFold#GetRstFold()
  setlocal foldtext=RstFold#GetRstFoldText()
  augroup RstFold
    autocmd TextChanged,InsertLeave <buffer> unlet! b:RstFoldCache
  augroup END
endif

" Syntax Highlighting: {{{1
" he rst.vim or ft-rst-syntax or syntax 2600. Don't put bash instead of sh.
" $VIMRUNTIME/syntax/rst.vim iterates over this var and if it can't find a
" bash.vim syntax file it will crash.

" May 13, 2019: Updated. Grabbed this directly from $VIMRUNTIME/syntax/rst.vim
"
" Use fewer code lists it ends up accounting for 50% of startuptime when
" using rst docs
let g:rst_syntax_code_list = {
    \ 'python': ['python', 'python3', 'ipython'],
    \ 'sh': ['sh'],
    \ }

" can't use java in the syntax list anymore this shit takes way too long

" Atexit: {{{1
let b:undo_ftplugin = 'set et< ts< sw< sts< cms< com< cc< lbr< fdl< fdls< spell< kp<'
" can't use unlet! or unlet in the same '' apparently

let &cpoptions = s:cpo_save
unlet s:cpo_save
