" header
" recognize .snippet files
if has('autocmd')
    augroup snippetftd
        autocmd BufRead,BufNewFile *.ext,*.ext3|<buffer[=N]>
    augroup end
    autocmd BufNewFile,BufRead *.snippets set filetype snippets
endif
