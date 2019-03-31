" ============================================================================
    " File: snippets.vim
    " Author: Faris Chugthai
    " Description: Snippets modifications.
    " Last Modified: March 21, 2019
" ============================================================================

" Fold by syntax, but open all folds by default
setlocal foldmethod=syntax

let b:commentstring='# %s'

setlocal autoindent nosmartindent nocindent

" don't unset g:tagbar_type_snippets, it serves no purpose
let b:undo_ftplugin = "
            \ setlocal foldmethod< commentstring<
            \|setlocal autoindent< smartindent< cindent<
            \|if get(s:, 'set_match_words')
                \|unlet! b:match_ignorecase b:match_words s:set_match_words
            \|endif
            \"
