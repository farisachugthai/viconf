" ============================================================================
    " File: lang_client.vim
    " Author: Faris Chugthai
    " Description: Language Client plugin mods
    " Last Modified: Apr 16, 2019
" ============================================================================

if !has_key(plugs, 'LanguageClient-neovim')
    finish
endif

" DUDE THIS NEEDS TO BE BUFFER LOCAL NOT GLOBAL! We need to re-source this file
" every time we change filetypeeeee
if exists('b:did_conf_lang_client') || &compatible || v:version < 700
    finish
endif
let b:did_conf_lang_client = 1

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

let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_settingsPath = expand('$XDG_CONFIG_HOME') . '/nvim/settings.json'
let g:LanguageClient_loggingFile = expand('$XDG_DATA_HOME') . '/nvim/LC.log'

" WHY IS THIS SET TO 0 BY DEFAULT WTF. I've been trying to figure out why pyls doesn't
" respond to settings I defined in the settings file. Wow.
let g:LanguageClient_loadSettings = 1

" Mappings: {{{1
" This is a good way to give LangClient the necessary bindings it needs;
" while, first ensuring that the plugin loaded and that it only applies for
" relevant filetypes.

" You dickhead you never call the function??? Yeah let's not do that.
if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <Leader>lh <Cmd>call LanguageClient#textDocument_hover()<CR>
    " Jedi might steal this periodically
    if !hasmapto('<F2>')
        inoremap <buffer> <F2>       <Cmd>call LanguageClient#textDocument_rename()<CR>
    endif
    nnoremap <buffer> <Leader>ld <Cmd>call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <Leader>lr <Cmd>call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <Leader>lf <Cmd>call LanguageClient#textDocument_formatting()<CR>
    nnoremap <buffer> <Leader>lt <Cmd>call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <Leader>lx <Cmd>call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <Leader>la <Cmd>call LanguageClient_workspace_applyEdit()<CR>
    nnoremap <buffer> <Leader>lc <Cmd>call LanguageClient#textDocument_completion()<CR>
    nnoremap <buffer> <Leader>ls <Cmd>call LanguageClient_textDocument_documentSymbol()<CR>
    nnoremap <buffer> <Leader>lm <Cmd>call LanguageClient_contextMenu()<CR>
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
endif


" LanguageClient Check: {{{2
" Check if the LanguageClient is running.
function! g:LC_Check()
  echo LanguageClient#serverStatus()
endfunction

command! LCS call g:LC_Check()
