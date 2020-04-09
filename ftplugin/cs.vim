" Vim filetype plugin file
" Language:	C#

if exists("b:did_ftplugin") | finish | endif

" Options: {{{
source $VIMRUNTIME/ftplugin/cs.vim

setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
compiler cs

setlocal makeprg=csc\ %:S

" }}}

" Mappings: {{{
" The following commands are contextual, based on the cursor position.
nnoremap <buffer> gd <Cmd>OmniSharpGotoDefinition<CR>
nnoremap <buffer> <Leader>fi <Cmd>OmniSharpFindImplementations<CR>
nnoremap <buffer> <Leader>fs <Cmd>OmniSharpFindSymbol<CR>
nnoremap <buffer> <Leader>fu <Cmd>OmniSharpFindUsages<CR>
nnoremap <buffer> <Leader>fm <Cmd>OmniSharpFindMembers<CR>
nnoremap <buffer> <Leader>fx <Cmd>OmniSharpFixUsings<CR>
nnoremap <buffer> <Leader>tt <Cmd>OmniSharpTypeLookup<CR>
nnoremap <buffer> <Leader>dc <Cmd>OmniSharpDocumentation<CR>
nnoremap <buffer> <C-\\> <Cmd>OmniSharpSignatureHelp<CR>
inoremap <buffer> <C-\\> <Cmd>OmniSharpSignatureHelp<CR>
nnoremap <buffer> [m <Cmd>OmniSharpNavigateUp<CR>
nnoremap <buffer> ]m <Cmd>OmniSharpNavigateDown<CR>
nnoremap <buffer> <Leader>cc <Cmd>OmniSharpGlobalCodeCheck<CR>

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <buffer> <Leader><Space> <Cmd>OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <buffer> <Leader><Space> <Cmd>call OmniSharp#GetCodeActions('visual')<CR>

nnoremap <buffer> <Leader>cf <Cmd>OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <buffer> <Leader>ss <Cmd>OmniSharpStartServer<CR>
nnoremap <buffer> <Leader>sp <Cmd>OmniSharpStopServer<CR>

" Rename with dialog
nnoremap <buffer> <Leader>nm <Cmd>OmniSharpRename<CR>
nnoremap <buffer> <F2> <Cmd>OmniSharpRename<CR>
" }}}

" Commands: {{{
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 -buffer OmniRename call OmniSharp#RenameTo(<f-args>)

" }}}

" Literally Why Dont The Official Ftplugins Have Undo FTPlugins:{{{
let b:undo_ftplugin = 'setlocal fo< com< et< sts< sw< ts< mp<'
      \. '|silent! nunmap <buffer> gd'
      \. '|silent! nunmap <buffer> <Leader>fi'
      \. '|silent! nunmap <buffer> <Leader>fs'
      \. '|silent! nunmap <buffer> <Leader>fu'
      \. '|silent! nunmap <buffer> <Leader>fm'
      \. '|silent! nunmap <buffer> <Leader>fx'
      \. '|silent! nunmap <buffer> <Leader>tt'
      \. '|silent! nunmap <buffer> <Leader>dc'
      \. '|silent! iunmap <buffer> <C-\\>'
      \. '|silent! nunmap <buffer> <C-\\>'
      \. '|silent! nunmap <buffer> [m'
      \. '|silent! nunmap <buffer> ]m'
      \. '|silent! nunmap <buffer> <Leader>cc'
      \. '|silent! nunmap <buffer> <Leader><Space>'
      \. '|silent! xunmap <buffer> <Leader><Space>'
      \. '|silent! nunmap <buffer> <Leader>nm'
      \. '|silent! nunmap <buffer> <Leader>cf'
      \. '|silent! nunmap <buffer> <Leader>ss'
      \. '|silent! nunmap <buffer> <Leader>sp'
      \. '|silent! nunmap <buffer> <Leader>nm'
      \. '|silent! nunmap <buffer> <F2>'
      \. '|silent! delcom OmniRename'
      \. '|unlet! b:undo_ftplugin'
      \. '|unlet! b:current_compiler'
      \. '|unlet! b:did_ftplugin'

