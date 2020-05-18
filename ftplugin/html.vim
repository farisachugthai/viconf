" ============================================================================
  " File: html.vim
  " Author: Faris Chugthai
  " Description: Html ftplugin
  " Last Modified: June 08, 2019
" ============================================================================

" css, js, jinja2, htmljinja and htmldjango all need things from here
" so don't only check that filetype is right.
" if &filetype !=# 'html' | finish | endif
"
" from runtime/ftplugin/html.vim
let g:ft_html_autocomment = 1

" Source theirs in first so we can overwrite it at will
source $VIMRUNTIME/ftplugin/html.vim
" I would mention that an htmldjango indent file exists but its 1 line
" runtime! indent/html.vim

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal suffixesadd+=.html

" So this is from |ft-html-omni| I don't know if that call is necessary
if &omnifunc ==# ''
  setlocal omnifunc=htmlcomplete#CompleteTags
endif

call htmlcomplete#DetectOmniFlavor()

" From the help docs on matchit. Not gonna check for existence since we
" should've gotten theirs. Takeaway lesson. Use .\{-} as often as necessary.
" .* will fuck you.
let b:match_words.='<.\{-}>:<[^>]*>'

let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])
" he checks for executability too let's say fuck it
let b:ale_fixers += ['prettier', 'stylelint', 'csslint']

" Official ftplugin doesn't put did_ftplugin in the undo wth
let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
                  \. '|setlocal et< sw< sts< sua< ofu<'
                  \. '|unlet! b:undo_ftplugin'
                  \. '|unlet! b:match_ignorecase b:match_skip b:match_words b:browsefilter'
                  \. '|unlet! b:did_ftplugin'
