" ============================================================================
    " File: markdown.vim
    " Author: Faris Chugthai
    " Description: Markdown ftplugin. Shamelessly stolen from @tpope
    " Last Modified: Aug 24, 2019
" ============================================================================

" Needed to autoload the funcs and drop the runtime! to a runtime html call

" Guard: {{{1
if exists("b:did_ftplugin")
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|setl cms< com< fo< flp<"
else
  let b:undo_ftplugin = "setl cms< com< fo< flp<"
endif

" Enable spellchecking.
setlocal spell!

" Automatically wrap at 80 characters after whitespace
setlocal textwidth=80
setlocal colorcolumn=80
" Then break lines if they're too long.
" setlocal linebreak

" Fix tabs so that we can have ordered lists render properly
setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

setlocal foldlevel=1 foldlevelstart=1

" TPope's markdown plugin. Light enough footprint when settings vars to not
" need a check
let g:markdown_fenced_languages = [ 'python', 'bash=sh']

let g:markdown_minlines = 100

" Mappings: {{{1

noremap <buffer> <localleader>1 m`yypVr=``
noremap <buffer> <localleader>2 m`yypVr-``
noremap <buffer> <localleader>3 m`^i### <esc>``4l
noremap <buffer> <localleader>4 m`^i#### <esc>``5l
noremap <buffer> <localleader>5 m`^i##### <esc>``6l

" Atexit: {{{1

let b:undo_ftplugin .= ' spell< cc< tw< et< ts< sts< sw< fdl< fdls<'
let g:markdown_folding = 1

if has("folding") && exists("g:markdown_folding")
  setlocal foldexpr=format#MarkdownFoldText()
  setlocal foldmethod=expr
  let b:undo_ftplugin .= " foldexpr< foldmethod<"
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
