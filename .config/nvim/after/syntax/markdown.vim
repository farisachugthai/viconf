" ============================================================================
    " File: markdown.vim
    " Author: Faris Chugthai
    " Description: Markdown.vim
    " Last Modified: April 17, 2019
" ============================================================================

" 12/17/2018
" Line 130:
" syn match markdownError \w\@<=_\w\@=
" That's probably a pretty standard LOC AND it's defines _ as an error!!!!! Dude we need to disable
" that because it drives me FUCKING NUTS. Idk what we need to do to check it {whether we run
" syn match or what we have to do. But we'll figure it out because it's driving me crazy.

" HACK
highlight! link markdownError markdownText

" Apr 17, 2019:
" Back again! hi markdownItalic doesn't link...to Italic text? Actually it doesn't really seem like much does.
