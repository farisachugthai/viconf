" ============================================================================
  " File: autocmd.vim
  " Author: Faris Chugthai
  " Description: Auto commands
  " Last Modified: February 17, 2020
" ============================================================================

" if exists('g:loaded_autocmd') || &compatible || v:version < 700
"   finish
" endif
" let g:loaded_autocmd = 1

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

augroup UserHelpandPython " {{{
  au!
  autocmd FileType man,help setlocal number relativenumber
  autocmd FileType man,help  if winnr('$') > 1
        \| wincmd T
        \| endif

  autocmd FileType python exec 'source ' . s:repo_root . '/ftplugin/python.vim'
  autocmd FileType python let &l:path = py#PythonPath()
  autocmd FileType python call py#ALE_Python_Conf()
augroup END
" }}}

augroup UserCoc " {{{
  au!
  autocmd User CocStatusChange,CocDiagnosticChange
        \| if exists('*Statusline_expr')
        \| call Statusline_expr()
        \| endif

  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  autocmd! User CmdlineEnter CompleteDone

augroup END

" }}}

augroup UserVimEnter " {{{
  autocmd!
  autocmd VimEnter * colorscheme gruvbox-material
  " idk how i fucked up but this now necessary?
  autocmd VimEnter * exec 'so ' . s:repo_root . '/plugin/plugins.vim'
augroup end
" }}}

if !has('nvim') | finish | endif

augroup UserTerm " {{{
  au!
  autocmd TermOpen * setlocal statusline=%{b:term_title}

  " `set nomodified` so Nvim stops prompting you when you
  " try to close a buftype==terminal buffer. afterwards clean up the window
  autocmd TermOpen * setlocal nomodified norelativenumber foldcolumn=0 signcolumn=

  " April 14, 2019: To enter |Terminal-mode| automatically:
  autocmd TermOpen * startinsert

  " Jul 17, 2019: It's been like 3 months and I only recently realized
  " that I didn't mention to leave insert mode when the terminal closes...
  autocmd TermClose * stopinsert

  " Set up mappings
  autocmd TermOpen * call buffers#terminals()
augroup END
" }}}
