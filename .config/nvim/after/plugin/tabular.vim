" ============================================================================
    " File: tabular.vim
    " Author: Faris Chugthai
    " Description: Really useful example in Tabular docs
    " Last Modified: June 15, 2019
" ============================================================================

" Guard: {{{1
if !has_key(plugs, 'tabular')
    finish
endif

if exists('g:did_tabular_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_tabular_after_plugin = 1

" Official Docs: {{{1
" Dude these are from the docs this is awesome!
" after/plugin/my_tabular_commands.vim
" Provides extra :Tabularize commands

if !exists(':Tabularize')
finish " Give up here; the Tabular plugin musn't have been loaded
endif

" Make line wrapping possible by resetting the 'cpo' option, first saving it
let s:save_cpo = &cpo
set cpo&vim

AddTabularPattern! asterisk /*/l1

AddTabularPipeline! remove_leading_spaces /^ /
          \ map(a:lines, "substitute(v:val, '^ *', '', '')")

" Restore the saved value of 'cpo'
let &cpo = s:save_cpo
unlet s:save_cpo
