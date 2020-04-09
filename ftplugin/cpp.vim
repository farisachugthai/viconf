" Vim filetype plugin file
" Language:	C++
" Maintainer: Faris Chugthai
" Last Change: Nov 06, 2019

" Only do this when not done yet for this buffer

if exists('b:did_ftplugin') | finish | endif

" Also account for my mods. Where all the meat is
let s:root_dir = fnameescape(fnamemodify(expand('<sfile>'), ':p:h:h'))
exec 'source ' . s:root_dir . '/ftplugin/c.vim'

" dont source $VIMRUNTIME/ftplugin/cpp.vim
" fucking hate when all we do is runtime! ftplugin/c.vim
source $VIMRUNTIME/indent/cpp.vim

setlocal syntax=c
setlocal matchpairs+==:;
" As a reminder i think this setting changes gq and affect how stuff like
" textwidth is handled and shit.
setlocal formatprg=ftplugins#FormatFile
setlocal keywordprg=:Man

let &l:define = '^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)'

setlocal cindent
let b:ale_fixers = get(g:, 'ale_fixers["*"]', ['remove_trailing_lines', 'trim_whitespace'])

let b:ale_fixers += [ 'clang-format' ]

" From clang.:
" With this integration you can press the bound key and clang-format will
" format the current line in NORMAL and INSERT mode or the selected region in
" VISUAL mode. The line or region is extended to the next bigger syntactic
" entity.

" You can also pass in the variable "l:lines" to choose the range for
" formatting. This variable can either contain "<start line>:<end line>" or
" "all" to format the full file. So, to format the full file, write a function
" like:

" It operates on the current, potentially unsaved buffer and does not create
" or save any files. To revert a formatting, just undo.
augroup UserFtpluginFormatter
  au!
  autocmd BufWritePre *.h,*.cc,*.cpp call format#ClangCheck()

augroup END

" Go with a spacemacs style binding
nnoremap <buffer> <Leader>ef <Cmd>py3file $XDG_CONFIG_HOME . '/nvim/pythonx/clang-format.py'


" Defined in my ./c.vim
let b:undo_ftplugin .= '|setlocal syntax< fp< mps< kp< cin<'
      \ . '|unlet! b:undo_ftplugin'
      \ . '|unlet! b:did_ftplugin'
      \ . '|silent! <buffer> nunmap <Leader>ef'
