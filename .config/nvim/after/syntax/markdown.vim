" Markdown.vim

" Line 130:
" syn match markdownError \w\@<=_\w\@=
" That's probably a pretty standard LOC AND it's defines _ as an error!!!!! Dude we need to disable
" that because it drives me FUCKING NUTS. Idk what we need to do to check it {whether we run
" syn match or what we have to do. But we'll figure it out because it's driving me crazy.

" HACK
highlight! link markdownError markdownText
