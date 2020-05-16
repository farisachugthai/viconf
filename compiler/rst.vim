" Vim compiler file
" Compiler:             sphinx >= 1.0.8, http://www.sphinx-doc.org
" Description:          reStructuredText Documentation Format
" Maintainer:           Faris Chugthai
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      Jun 29, 2019


" Guards:
if exists('current_compiler')
  finish
endif
let current_compiler = 'rst'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif


" CompilerSet:
if exists('g:rst_makeprg_params')
  execute 'CompilerSet makeprg=sphinx-build\ ' . escape(g:rst_makeprg_params, ' \|"') . '\ $*'
else
  CompilerSet makeprg=sphinx-build\ $*
endif


augroup UserAutomakeRst
  autocmd FileType rst if executable('sphinx-build')
                    \|   if filereadable('conf.py')
                    \|     let &l:makeprg = 'sphinx-build -b html . ./build/html'
                    \|     nnoremap <buffer> <F5> <Cmd>make!<CR>
                    \|   elseif glob('../conf.py')
                    \|     let &l:makeprg = 'sphinx-build -b html .. ../../build/html '
                    \|     nnoremap <buffer> <F5> <Cmd>make!<CR>
                    \|   else
                    \|     let &l:makeprg = 'sphinx-build -b html'
                    \|     nnoremap <buffer> <F5> <Cmd>make!<Space>
                    \|   endif
                    \| endif
augroup END


CompilerSet errorformat=
      \%f\\:%l:\ %tEBUG:\ %m,
      \%f\\:%l:\ %tNFO:\ %m,
      \%f\\:%l:\ %tARNING:\ %m,
      \%f\\:%l:\ %tRROR:\ %m,
      \%f\\:%l:\ %tEVERE:\ %m,
      \%f\\:%s:\ %tARNING:\ %m,
      \%f\\:%s:\ %tRROR:\ %m,
      \%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',
      \%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',
      \%DMaking\ %*\\a\ in\ %f

