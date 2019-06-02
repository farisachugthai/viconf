" Compatible with ranger 1.4.2 through 1.7.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! vim_file_chooser#RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction

command! -bar RangerChooser call vim_file_chooser#RangeChooser()

nnoremap <leader>r :<C-U>RangerChooser<CR>

" Not ranger related but file choosing using Ag and Rg.

" Commands
" command! -bang -nargs=+ -complete=dir AgRaw call agriculture#fzf_ag_raw(agriculture#smart_quote_input(<q-args>), <bang>0)

" command! -bang -nargs=+ -complete=dir RgRaw call agriculture#fzf_rg_raw(agriculture#smart_quote_input(<q-args>), <bang>0)

" Mappings
" nnoremap <Plug>AgRawSearch :AgRaw<Space>

" nnoremap <Plug>RgRawSearch :RgRaw<Space>

" Mappings to search visual selection
" vnoremap <Plug>AgRawVisualSelection "ay:call agriculture#trim_and_escape_register_a()<CR>:AgRaw -Q -- $'<C-r>a'

" vnoremap <Plug>RgRawVisualSelection "ay:call agriculture#trim_and_escape_register_a()<CR>:RgRaw -F -- $'<C-r>a'

" Mappings to search word under cursor
" nnoremap <Plug>AgRawWordUnderCursor "ayiw:call agriculture#trim_and_escape_register_a()<CR>:AgRaw -Q -- $'<C-r>a'

" nnoremap <Plug>RgRawWordUnderCursor "ayiw:call agriculture#trim_and_escape_register_a()<CR>:RgRaw -F -- $'<C-r>a'
