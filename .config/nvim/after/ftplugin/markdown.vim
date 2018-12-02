" Markdown ftplugin
" Maintainer: Faris Chugthai

" TODO: Fix the way that '_' is highlighted in md
" So that would be implemented in after/syntax/markdown.vim not here

" Enable spellchecking.
setlocal spell

" Automatically wrap at 80 characters after whitespace
setlocal textwidth=80
setlocal colorcolumn=80
" Then break lines if they're too long.
setl linebreak

" Fix tabs so that we can have ordered lists render properly
setlocal shiftwidth=2 softtabstop=2 tabstop=2

" whitelist markdownlint for ALE
" https://github.com/DavidAnson/markdownlint
" In that repo they have a doc called rules.md and we could configure that as
" necessary when we get there.
