" ============================================================================
    " File: lang_client.vim
    " Author: Faris Chugthai
    " Description: Language Client plugin mods
    " Last Modified: March 15, 2019
" ============================================================================

if !has_key(plugs, 'LanguageClient-neovim')
    finish
endif

if exists('g:did_conf_lang_client') || &compatible || v:version < 700
    finish
endif
let g:did_conf_lang_client = 1

" Options: {{{1

let g:LanguageClient_serverCommands = {
            \ 'python': [ 'pyls' ],
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'js': ['tsserver'],
            \ 'ts': ['tsserver'],
            \ 'css': ['css-languageserver'],
            \ 'html': ['html-languageserver'],
            \ 'tsx': ['tsserver']
            \ }

let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_settingsPath = expand('$XDG_CONFIG_HOME') . '/nvim/settings.json'
let g:LanguageClient_loggingFile = expand('$XDG_DATA_HOME') . '/nvim/LC.log'

" Mappings: {{{1
" This is a good way to give LangClient the necessary bindings it needs;
" while, first ensuring that the plugin loaded and that it only applies for
" relevant filetypes.
function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <Leader>lh :call LanguageClient#textDocument_hover()<CR>
        inoremap <buffer> <Leader><F2> <Esc>:call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <Leader>ld :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <Leader>lr :call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
        nnoremap <buffer> <Leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
        nnoremap <buffer> <Leader>lx :call LanguageClient#textDocument_references()<CR>
        nnoremap <buffer> <Leader>la :call LanguageClient_workspace_applyEdit()<CR>
        nnoremap <buffer> <Leader>lc :call LanguageClient#textDocument_completion()<CR>
        nnoremap <buffer> <Leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <buffer> <Leader>lm :call LanguageClient_contextMenu()<CR>
        set completefunc=LanguageClient#complete
        set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
    endif
endfunction

" Functions: {{{1

" LanguageClient Check: {{{2
" Check if the LanguageClient is running.
function! s:lc_check()
  let s:lc_Check = LanguageClient#serverStatus()
  echo s:lc_Check
endfunction

command! LCS call <SID>lc_check()
