" ============================================================================
    " File: signify.vim
    " Author: Faris Chugthai
    " Description: Signify configuration.
    " Last Modified: June 22, 2019
" ============================================================================

" Plugin Guard: {{{1

if !exists('g:plugs')
  finish
endif
if !has_key(plugs, 'vim-signify')
    finish
endif

if exists('g:did_signify_after_plugin') || &cp || v:version < 700
    finish
endif
let g:did_signify_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" Options: {{{1
let g:signify_vcs_list = [ 'git' ]

let g:signify_cursorhold_insert     = 1
let g:signify_cursorhold_normal     = 1
let g:signify_update_on_bufenter    = 0
let g:signify_update_on_focusgained = 1

" TODO: signify realtime and the git diff options

" Mappings: {{{1

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)

nnoremap <leader>st :SignifyToggle<CR>
nnoremap <leader>sh :SignifyToggleHighlight<CR>
nnoremap <leader>sr :SignifyRefresh<CR>
nnoremap <leader>sd :SignifyDebug<CR>

" Hunk Jumping:
nmap <leader>sj <plug>(signify-next-hunk)
nmap <leader>sk <plug>(signify-prev-hunk)
nmap <leader>sJ 9999<leader>gj
nmap <leader>sK 9999<leader>gk

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
