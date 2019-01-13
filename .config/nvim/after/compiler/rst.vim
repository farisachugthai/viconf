" Vim compiler file
" Compiler:             sphinx >= 1.0.8, http://www.sphinx-doc.org
" Description:          reStructuredText Documentation Format
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2017-03-31

" Uhhh this guy wrote all this but never defined a makeprg??

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Doubt we're allwoed to do this. No makeprg takes a string.
" So now run :make in your ./docs/ dir and it should work right?
CompilerSet makeprg='sphinx-build . -o _build'
