" Vim filetype plugin file
" Language:	C++
" Maintainer: Faris Chugthai
" Last Change: Nov 06, 2019

" Source:
  " Only do this when not done yet for this buffer
  if exists('b:did_ftplugin') | finish | endif

  " Also account for my mods. Where all the meat is
  let s:root_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h:h'))
  exec 'source ' . s:root_dir . '/ftplugin/c.vim'

  " dont source $VIMRUNTIME/ftplugin/cpp.vim
  " fucking hate when all we do is runtime! ftplugin/c.vim
  " This entire file only does
  " source $VIMRUNTIME/indent/cpp.vim
  setlocal cindent
  " So why don't we
  let b:did_indent = 1


" Options:
  setlocal syntax=cpp
  setlocal matchpairs+==:;
  " As a reminder i think this setting changes gq and affect how stuff like
  " textwidth is handled and shit.
  setlocal formatexpr=ftplugins#ClangCheck()
  setlocal keywordprg=:Man

  let &l:define = '^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)'
  let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

  let b:ale_fixers += [ 'clang-format' ]


let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal cin< syntax< mps< formatexpr< kp< def<'
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:undo_indent'
                \. '|unlet! b:ale_fixers'
                \. '|unlet! b:did_ftplugin'
