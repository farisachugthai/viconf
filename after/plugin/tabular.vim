" ============================================================================
    " File: tabular.vim
    " Author: Faris Chugthai
    " Description: Really useful example in Tabular docs
    " Last Modified: ddate
" ============================================================================

" Official Docs: {{{1
" Dude these are from the docs this is awesome!
" after/plugin/my_tabular_commands.vim
" Provides extra :Tabularize commands


" Make line wrapping possible by resetting the 'cpo' option, first saving it
let s:save_cpo = &cpo
set cpo&vim

AddTabularPattern! firstcomma /^[^,]*\zs,/l5c5

" I think the problem is that we lazy load it so maybe don't do that? idk
AddTabularPattern! asterisk /*/l1

AddTabularPipeline! remove_leading_spaces /^ /
          \ map(a:lines, "substitute(v:val, '^ *', '', '')")

" Restore the saved value of 'cpo'
let &cpo = s:save_cpo
unlet s:save_cpo
