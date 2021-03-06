" ============================================================================
    " File: markdown.vim
    " Author: Faris Chugthai
    " Description: Markdown ftplugin. Shamelessly stolen from @tpope
    " Last Modified: Aug 24, 2019
" ============================================================================


" Globals:
  " Set global vars before checking filetype!
  let g:markdown_fenced_languages = [
        \ 'ipython=python',
        \ ]

  " ensure to keep this around for the ftplugin
  let g:markdown_folding = 1
  let g:markdown_minlines = 500

  let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" Guards:
  if exists('b:did_ftplugin') | finish | endif
  let b:did_ftplugin = 1
  " source $VIMRUNTIME/ftplugin/markdown.vim
  " officially stole the whole thing

" Options:
  setlocal comments=fb:*,fb:-,fb:+,n:>
  " used to be
  " commentstring=>\ %s
  setlocal commentstring=<!--%s-->

  " So this doesn't behave as expected but we're working
  setlocal formatoptions=tcqanl1
  setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

  source $VIMRUNTIME/autoload/htmlcomplete.vim
  setlocal omnifunc=htmlcomplete#CompleteTags

  call htmlcomplete#DetectOmniFlavor()

  setlocal conceallevel=2
  " Enable spellchecking.
  setlocal spell!

  " Automatically wrap at 80 characters after whitespace
  " setlocal textwidth=80
  setlocal colorcolumn=80
  " Then break lines if they're too long.
  setlocal linebreak

  " Fix tabs so that we can have ordered lists render properly
  setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

  setlocal foldlevelstart=0

  exec 'source ' . s:repo_root . '/autoload/format.vim'
  setlocal foldexpr=format#MarkdownFoldText()
  setlocal foldmethod=expr

" Matchit:
  let b:match_ignorecase = 1
  if !exists('b:match_words') | let b:match_words = '' | endif

  let b:match_words .= ',<:>,<.\{-}>:<[^>]*>,'
        \. '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,'
        \. '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,'
        \. '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'

  let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
        \. '|setl cms< com< fo< flp< ofu< '
        \. '|setl spell< cc< tw< lbr< et< ts< sts< sw< fdl< fdls<'
        \. '|unlet! b:undo_ftplugin'
        \. '|unlet! b:did_ftplugin'
        \. '|unlet! b:match_ignorecase'
        \. '|unlet! b:match_words'
  let b:undo_ftplugin .= '|setlocal foldexpr< foldmethod<'

" Mappings:
  nnoremap <buffer> <Leader>1 m`yypVr=``
  nnoremap <buffer> <Leader>2 m`yypVr-``
  nnoremap <buffer> <Leader>3 m`^i### <esc>``4l
  nnoremap <buffer> <Leader>4 m`^i#### <esc>``5l
  nnoremap <buffer> <Leader>5 m`^i##### <esc>``6l

  let b:undo_ftplugin .= '|silent! nunmap <buffer> <Leader>1'
        \ . '|silent! nunmap <buffer> <Leader>2'
        \ . '|silent! nunmap <buffer> <Leader>3'
        \ . '|silent! nunmap <buffer> <Leader>4'
        \ . '|silent! nunmap <buffer> <Leader>5'

  " Here's a few operator pending mappings from steve losh
  onoremap <buffer> ih <Cmd>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<CR>
  onoremap <buffer> ah <Cmd>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<CR>

  let b:undo_ftplugin .= '|silent! ounmap <buffer> ih'
                     \.  '|silent! ounmap <buffer> ah'

" Plugins:
  " So Vim-markdown doesn't have a  plugin/* dir. So we don't have a
  " g:loaded_vim_markdown var to check. We have to assume vim-plug being used.
  " Don't freak out a bare nvim config though.
  if !exists('g:plugs') | finish | endif

  if has_key(g:plugs, 'vim-markdown')

    " dude this makes shit so slow
    let g:vim_markdown_folding_style_pythonic = 0
    " Folding level is a number between 1 and 6. By default, if not specified, it
    " is set to 1.
    let g:vim_markdown_folding_level = 2
    " Allow for the TOC window to auto-fit when it's possible for it to shrink.
    " It never increases its default size (half screen), it only shrinks.
    let g:vim_markdown_toc_autofit = 1
    let g:vim_markdown_follow_anchor = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_strikethrough = 1

    if exists('#Mkd')
      au! Mkd
    endif

  endif
