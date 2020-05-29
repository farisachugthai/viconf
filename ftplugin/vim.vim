" ============================================================================
    " File: vim.vim
    " Author: Faris Chugthai
    " Description: vim ftplugin
    " Last Modified: Nov 14, 2019
" ============================================================================

" Globals:
  let g:vimsyn_minlines = 300
  let g:vimsyn_maxlines = 500  " why is the default 60???
  let g:vimsyn_noerror = 1  " Turn off errors because 50% of them are wrong.
  let g:vimsyn_embed = 1

if exists('b:did_ftplugin') | finish | endif

" Filetype Specific Options:
  " Override the textwidth before sourcing the runtime ftplugin. They do
  " if tw=0 | setlocal tw=78 | endif
  setlocal textwidth=100

  " Also let's check that this is the right filetype because this is expensive
  " Then we don't need to add it to our ftplugin_undo because it's in that func call
  if &filetype ==# 'vim'
    source $VIMRUNTIME/ftplugin/vim.vim
  endif

  setlocal expandtab
  setlocal shiftwidth=2
  setlocal tabstop=8
  setlocal softtabstop=2
  setlocal suffixesadd=.vim
  setlocal nolinebreak

  setlocal wrapmargin=1
  " To allow tag lookup via CTRL-] for autoload functions, '#' must be a
  " keyword character.  E.g., for netrw#Nread().
  " Wanted - added so we could search for stuff like vim-surround as 1 word
  " Think tpope adds it in scriptease tho
  " setlocal iskeyword+=#,-  " Make 'gf' work
  setlocal wrap
  setlocal foldmethod=indent
  setlocal foldlevel=0

  let &l:path = includes#VimPath()

  setlocal tags+=~/.config/nvim/tags,$VIMRUNTIME/doc/tags,tags,**

" ALE And Cleanup:
  if !exists('s:stddata')
    if exists('*stdpath')
      let s:stddata = stdpath("data")
    else
      let s:stddata = resolve(expand('~/.local/share/nvim'))
    endif
  endif

  let &l:tags .= s:stddata . '/plugged'
  let b:undo_indent = 'setlocal indentkeys< indentexpr<'

  let b:ale_linters = ['ale_custom_linting_rules', 'vint', 'vimls']
  let b:ale_linters_explicit = 1

" the original ftplugin also sets b:undo_ftplugin = to call VimFtpluginUndo
" so we can append to theirs and not need to add rhe func call
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                \. '|setlocal et< sw< ts< sts< lbr< sua< wrap<'
                \. '|setlocal fdl< fdm< cms< path< isf< isk<'
                \. '|setlocal path< indentexpr< indentkeys< tags<'
                \. '|unlet! b:undo_ftplugin'
                \. '|unlet! b:undo_indent'
                \. '|unlet! b:did_ftplugin'
                \. '|unlet! b:ale_linters'
                \. '|unlet! b:ale_explicit'
