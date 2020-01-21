" ============================================================================
    " File: markdown.vim
    " Author: Faris Chugthai
    " Description: Markdown ftplugin. Shamelessly stolen from @tpope
    " Last Modified: Aug 24, 2019
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

if &filetype !=# 'markdown' | finish | endif

runtime ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

if exists('b:did_ftplugin') | unlet! b:did_ftplugin | endif

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|setl cms< com< fo< flp< "
else
  let b:undo_ftplugin = "setl cms< com< fo< flp< "
endif

" Enable spellchecking.
" setlocal spell!

" Automatically wrap at 80 characters after whitespace
setlocal textwidth=80
setlocal colorcolumn=80
" Then break lines if they're too long.
setlocal linebreak

" Fix tabs so that we can have ordered lists render properly
setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

setlocal foldlevel=0 foldlevelstart=0

" TPope's markdown plugin. Light enough footprint when settings vars to not
" need a check
let g:markdown_fenced_languages = [
      \ 'ipython=python',
      \ 'c++=cpp',
      \ 'ini=dosini',
      \ ]

let g:markdown_minlines = 100

let g:markdown_folding = 1

if has("folding") && exists("g:markdown_folding")
  setlocal foldexpr=format#MarkdownFoldText()
  setlocal foldmethod=expr
  let b:undo_ftplugin .= "| setlocal foldexpr< foldmethod<"
endif

" Mappings: {{{1

nnoremap <buffer> <Leader>1 m`yypVr=``
nnoremap <buffer> <Leader>2 m`yypVr-``
nnoremap <buffer> <Leader>3 m`^i### <esc>``4l
nnoremap <buffer> <Leader>4 m`^i#### <esc>``5l
nnoremap <buffer> <Leader>5 m`^i##### <esc>``6l

let b:undo_ftplugin .= ' nunmap <buffer> <Leader>1'
let b:undo_ftplugin .= ' nunmap <buffer> <Leader>2'
let b:undo_ftplugin .= ' nunmap <buffer> <Leader>3'
let b:undo_ftplugin .= ' nunmap <buffer> <Leader>4'
let b:undo_ftplugin .= ' nunmap <buffer> <Leader>5'

" So Vim-markdown doesn't have a  plugin/* dir. So we don't have a
" g:loaded_vim_markdown var to check. We have to assume vim-plug being used.
" Don't freak out a bare nvim config though.
if !exists('plugs') | finish | endif

if has_key(plugs, 'vim-markdown')
  let g:vim_markdown_folding_style_pythonic = 1
  " Folding level is a number between 1 and 6. By default, if not specified, it
  " is set to 1.
  let g:vim_markdown_folding_level = 2
  " Allow for the TOC window to auto-fit when it's possible for it to shrink.
  " It never increases its default size (half screen), it only shrinks.
  let g:vim_markdown_toc_autofit = 1
  " let g:vim_markdown_math = 1
  let g:vim_markdown_follow_anchor = 1
  let g:vim_markdown_frontmatter = 1
  " let g:vim_markdown_toml_frontmatter = 1
  " let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_strikethrough = 1

  if exists('#Mkd')
    au! Mkd
  endif

endif

let b:did_ftplugin = 1
let b:undo_ftplugin .= 'setl spell< cc< tw< lbr< et< ts< sts< sw< fdl< fdls<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
