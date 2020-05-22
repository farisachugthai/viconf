" =======================================================================
  " File: info.vim
  " Author: Faris Chugthai
  " Description: info files
  " Last Modified: May 14, 2020
" =======================================================================

if exists('b:did_ftplugin') | finish | endif
source $VIMRUNTIME/ftplugin/help.vim

" Path:
  let s:path='.,**,,'

  if exists('$PREFIX')
    let s:root  = expand('$PREFIX')
  else
    let s:root  = '/usr'
  endif

  let s:path = s:path . s:root. '/share/info,' . s:root . '/local/share/info,'
  let &l:path = s:path

" Options:
  setlocal suffixesadd=.gz
  setlocal foldmethod=marker foldlevelstart=0 foldignore= foldminlines=0

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|setlocal syntax< path< sua<'
                      \. '|setlocal fdm< fdls< foldignore< foldminlines<'
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'

