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

highlight! link markdownError markdownText

" TODO: Definitely check out the $VIMRUNTIME/syntax/markdown.vim file
" Jun 18, 2019:
" In december I definitely didn't understand what was going on at all
" but I actually just skimmed it and, while not understanding certain
" sections I actually had a good idea what was going on. Only reason I opened
" it was to check for a `syn match
" markdown*KeywordSimilartoCommentThatYouOverLooked
"
" " TPope defined most of the highlighting with highlight def link so you can
" override whatever you want man. We probably didn't need to chalk up
" markdownError to text so let's come back and fix this at some point.
" syn match markdownComment 
