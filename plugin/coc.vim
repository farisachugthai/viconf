" ============================================================================
    " File: coc.vim
    " Author: Faris Chugthai
    " Description: Coc plugin mods
    " Last Modified: Sep 26, 2019
" ============================================================================

" Most Global options are in ../../coc_settings.json
if exists('plugs')  " installed with vim-plug
  if index(keys(plugs), 'coc.nvim') == -1
    " yes i actually mean the #. If this gets funky check that -1 the number
    " is being compared to the number not the str
    finish
  endif
endif

" Options: {{{
" TODO:
" so obviously only do this on windows. shit there are so many things that we need to configure
" list.source.tags.command: ~/bin/ctags.exe -R --options=~/.ctags/universal_ctags.ctags .,

" if exists('g:node_host_prog') | let g:coc_node_path = g:node_host_prog | endif
if !has('unix')
  let g:coc_node_path = 'C:\Users\fac\scoop\apps\nvm\current\v13.7.0\node.exe'
endif

" TODO:
" May have to extend after a has('unix') check.
" Yeah probably need to make system checks to get rid of incorrect
" non portable definitions in the JSON file.
let g:WorkspaceFolders = [
      \ stdpath('config'),
      \ expand('$HOME/projects/dynamic_ipython'),
      \ expand('$HOME/projects/viconf'),
      \ expand('$HOME/python/tutorials'),
      \ ]

let g:coc_quickfix_open_command = 'cwindow'
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

let g:coc_enable_locationlist = 1
let $NVIM_COC_LOG_LEVEL = 'WARN'
let $NVIM_COC_LOG_FILE = stdpath('data') . '/site/coc.log'
let $NVIM_NODE_LOG_FILE = stdpath('data') . '/site/node.log'
let $NVIM_NODE_LOG_LEVEL = 'WARN'

" This raises a lot of errors
" call coc#snippet#enable()
" }}}

" Mappings: {{{

" General Mappings: {{{
" TODO: Might need to open a pull request he states that these are mapped by
" default. omap af and omap if didn't show anything
onoremap af <Plug>(coc-funcobj-a)
onoremap if <Plug>(coc-funcobj-i)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" So I got rid of supertab and ultisnips is finally set in a consistent way
" with inoremaps and FZF and doesn't overlap with too much of the C-x C-f
" family and their abbreviations. JESUS that got tough.

" Let's give Coc the tab key. If this doesn't work as expected we can also go
" with something like <M-/>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()


" Refresh completions with C-Space
inoremap <expr> <C-Space> coc#refresh()

" As a heads up theres also a coc#select#snippet
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap gK <Plug>(coc-definition)<CR>
" The gu<text object> operation is too important
" nnoremap <expr><buffer> gu <Plug>(coc-usages)<CR>
nnoremap g} <Plug>(coc-usages)<CR>
" }}}

" Bracket maps: {{{
" Shit none of these work
" oh also these are builtin mappings
" nnoremap [g <Plug>(coc-diagnostic-prev)<CR>
" nnoremap ]g <Plug>(coc-diagnostic-next)<CR>

" Note: Tried adding <expr> and didn't work
" nnoremap [c  <Plug>(coc-git-prevchunk)<CR>
" nnoremap ]c  <Plug>(coc-git-nextchunk)<CR>
" }}}

" Remap for rename current word: {{{
nnoremap <F2> <Plug>(coc-refactor)<CR>

" Instead of actually writing a '<,'> are we allowed to use the * char?
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>
" }}}

" CocOpenLog: {{{2
" TODO: Why does this raise an error?
" nnoremap <expr> ,l coc#client#open_log()
nnoremap ,l <Cmd>CocOpenLog<CR>
" And let's add one in for CocInfo
nnoremap ,i <Cmd>CocInfo<CR>
" }}}

" Grep By Motion: Mnemonic CocSelect {{{2

" Don't use vmap I don't want this in select mode!
" Yo why dont we use onoremap though?
" Q: How to grep by motion?
" A: Create custom keymappings like:
xnoremap ,cs :<C-u>call plugins#GrepFromSelected(visualmode())<CR>
nnoremap ,cs :<C-u>set operatorfunc=plugins#GrepFromSelected<CR>g@

" Show all diagnostics
command! -nargs=0 CocDiagnostic call CocActionAsync('diagnosticInfo')
" }}}

" Maps For CocList X: {{{
nnoremap <C-g> <Cmd>CocList<CR>
nnoremap ,d  <Cmd>CocList diagnostics<CR>
" nnoremap ,d <Plug>(coc-diagnostic-info)<CR>

" Manage extensions
nnoremap ,e  <Cmd>CocList extensions<CR>
" Show commands
nnoremap ,c  <Cmd>CocList commands<CR>
" Find symbol of current document
nnoremap ,o  <Cmd>CocList outline<CR>
" Search workspace symbols
nnoremap ,s  <Cmd>CocList -I symbols<CR>

" Easier Grep Using CocList Words:
nnoremap ,w <Cmd>execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'<CR>

" Keymapping for grep word under cursor with interactive mode
nnoremap ,g <Cmd>exe 'CocList -I --input=' . expand('<cword>') . ' grep'<CR>
" }}}

" CocResume: {{{
" Amazingly leader j k and p aren't taken. From the readme
nnoremap <Leader>j  :<C-u>CocNext<CR>
nnoremap ,j  :<C-u>CocNext<CR>
nnoremap <Leader>k  :<C-u>CocPrev<CR>
nnoremap ,k  :<C-u>CocPrev<CR>
nnoremap <Leader>r  :<C-u>CocListResume<CR>
nnoremap ,r  :<C-u>CocListResume<CR>
" }}}

" Other Mappings: {{{
xnoremap ,m  <Plug>(coc-format-selected)<CR>
nnoremap ,m  <Plug>(coc-format-selected)<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xnoremap ,a  <Plug>(coc-codeaction-selected)<CR>
" Remap for do codeAction of current line
nnoremap ,a  <Plug>(coc-codeaction)<CR>

" Now codeLens. No reason for h outside of it not being bound.
nnoremap ,h <Plug>(coc-codelens-action)<CR>

" Open the URL in the same way as netrw
nnoremap gx <Plug>(coc-openlink)<CR>

" Coc Usages
nnoremap ,u <Plug>(coc-references)<CR>

nnoremap ,. <Plug>(coc-command-repeat)<CR>

" Autofix problem of current line
nnoremap ,f  <Plug>(coc-fix-current)<CR>
nnoremap ,q  <Plug>(coc-fix-current)<CR>
" }}}
" }}}

" Commands: {{{

command! -nargs=0 CocWords execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'

command! -nargs=0 CocRepeat call CocAction('repeatCommand')

command! -nargs=0 CocReferences call CocAction('jumpReferences')

" TODO: Figure out the ternary operator, change nargs to ? and if arg then
" input=arg else expand(cword)
command! -nargs=0 CocGrep execute 'CocList -I --input=' . expand('<cword>') . ' grep'

" Dec 05, 2019: Got a new one for ya!
command! -nargs=0 CocExtensionStats :py3 from pprint import pprint; pprint(vim.eval('CocAction("extensionStats")'))

" Let's group these together by prefixing with Coc
" Use `:Format` to format current buffer
command! CocFormat call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold call CocActionAsync('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! CocSort call CocAction('runCommand', 'editor.action.organizeImport')

" Just tried this and it worked! So keep checking :CocList commands and add
" more as we go.
command! CocPython call CocActionAsync('runCommand', 'python.startREPL')|

" Let's also get some information here.
" call CocAction('commands') is a lamer version of CocCommand
" similar deal with CocFix and CocAction() -quickfix
" actually ive overriding his coc fix  giving it the quickfix arg fucks
" something up

command! -nargs=* -range CocFix call coc#rpc#notify('codeActionRange', [<line1>, <line2>, <q-args>])

" Nabbed these from his plugin/coc.vim file and changed the mappings to
" commands
command! CocDefinition call CocAction('jumpDefinition')

command! CocDeclaration    call       CocAction('jumpDeclaration')
command! CocImplementation call       CocAction('jumpImplementation')
command! CocTypeDefinition call       CocAction('jumpTypeDefinition')
command! CocReferences     call       CocAction('jumpReferences')
command! CocOpenlink      call       CocActionAsync('openLink')
command! CocFixCurrent    call       CocActionAsync('doQuickfix')
command! CocFloatHide     call       coc#util#float_hide()
command! CocFloatJump     call       coc#util#float_jump()
command! CocCommandRepeat call       CocAction('repeatCommand')

" }}}

" Autocmds: {{{

augroup UserCoc
  au!
  autocmd User CocStatusChange,CocDiagnosticChange
        \| if exists('*Statusline_expr')
        \| call Statusline_expr()
        \| endif

  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  autocmd! User CmdlineEnter CompleteDone

augroup END
" }}}

" Vim: set fdm=marker:
