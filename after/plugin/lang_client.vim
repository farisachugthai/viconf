" ============================================================================
    " File: lang_client.vim
    " Author: Faris Chugthai
    " Description: Language Client plugin mods
    " Last Modified: Apr 16, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'LanguageClient-neovim')
    finish
endif

" This needs to be buffer local not global! We need to re-source this file.
" every time we change filetypeeeee
if exists('b:did_language_client_after_plugin') || &compatible || v:version < 700
    finish
endif
let b:did_language_client_after_plugin = 1

" Options: {{{1
let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
            \ 'python': [ 'pyls' ],
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'js': ['tsserver'],
            \ 'ts': ['tsserver'],
            \ 'css': ['css-languageserver'],
            \ 'html': ['html-languageserver'],
            \ 'tsx': ['tsserver'],
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ }

let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_settingsPath = expand('$XDG_CONFIG_HOME') . '/nvim/settings.json'
let g:LanguageClient_loggingFile = expand('$XDG_DATA_HOME') . '/nvim/LC.log'

" WHY IS THIS SET TO 0 BY DEFAULT WTF. I've been trying to figure out why pyls doesn't
" respond to settings I defined in the settings file. Wow.
let g:LanguageClient_loadSettings = 1

" Mappings: {{{1

if has_key(g:LanguageClient_serverCommands, &filetype)
  " And as a double check I ran :echo has_key(g:LanguageClient_serverCommands, &filetype)
  " in a vim buffer and got the expected 0 and ran it again in a python buffer and got
  " the expected 1
    noremap <buffer> <Leader>lh <Cmd>call LanguageClient#textDocument_hover()<CR>

    " Jedi might steal this periodically
    if !hasmapto('<F2>')
        inoremap <buffer> <F2>   <Cmd>call LanguageClient#textDocument_rename()<CR>
    endif
    " Regardless this can work as a fallback
    noremap <buffer> <Leader>lr <Cmd>call LanguageClient#textDocument_rename()<CR>
    noremap <buffer> <Leader>ld <Cmd>call LanguageClient#textDocument_definition()<CR>
    noremap <buffer> <Leader>lf <Cmd>call LanguageClient#textDocument_formatting()<CR>
    noremap <buffer> <Leader>lt <Cmd>call LanguageClient#textDocument_typeDefinition()<CR>
    noremap <buffer> <Leader>lx <Cmd>call LanguageClient#textDocument_references()<CR>
    noremap <buffer> <Leader>la <Cmd>call LanguageClient_workspace_applyEdit()<CR>
    noremap <buffer> <Leader>lc <Cmd>call LanguageClient#textDocument_completion()<CR>
    noremap <buffer> <Leader>ls <Cmd>call LanguageClient_textDocument_documentSymbol()<CR>
    noremap <buffer> <Leader>lm <Cmd>call LanguageClient_contextMenu()<CR>
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
endif

" Commands: {{{1

" LanguageClient Check:

" Check if the LanguageClient is running.
function! g:LC_Check()
  " No args
  " exists(*funcname) is how you can check if either a built-in function or a
  " user-defined function exists
	if exists('*g:LC_Check')
    echo LanguageClient#serverStatus()
  else
    " It'll probably be a good idea to start prefixing echoed messages
    " so i can figure out where they came from
    echo 'viconf#after#plugin: LanguageClient#serverStatus() not registered'
endfunction

command! LCS call g:LC_Check()
