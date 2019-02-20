" FZF Configuration:

" FZF: {{{1
if has('nvim') || has('gui_running')
    " Wait hold on...if we already set it, then use my bashrc!
    if exists('$FZF_DEFAULT_OPTS') == 0
        let $FZF_DEFAULT_OPTS .= ' --inline-info'
    endif
endif

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_history_dir = expand('~/.local/share/fzf-history')

" FZF Colors: {{{1
" Customize FZF colors to match your color scheme
" What are the default colors if you don't specify this?
" **I think fzf.vim specifies this for us**

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLiVne', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Mappings: {{{1
" Specifically from that repo so I don't get stuff mixed up if I ever take one
" off or something

" Exported fzf <plug> commands.
imap <c-x><k> <Plug>(fzf-complete-word)
imap <c-x><f> <Plug>(fzf-complete-path)
imap <c-x><j> <Plug>(fzf-complete-file-ag)

nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>

" Shows all normal mode mappings.
nmap <leader><tab>  <Plug>(fzf-maps-n)
omap <leader><tab>  <Plug>(fzf-maps-o)
xmap <leader><tab>  <Plug>(fzf-maps-x)

" Command Local Options: {{{2

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="h%d %s %c(black)%c(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R ./** && ctags -R --append ./.*'

" [Commands] --expect expression for directly executing the command
" Wait what happens if we hit those though?
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Ag: {{{1
" :Ag  - Start fzf with hidden preview window that can be enabled with '?' key
" :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Global Line Completion: {{{2
" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" FZF_Statusline: {{{1

" Custom fzf statusline function: {{{2
function! s:fzf_statusline()
    " Override statusline as you like
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

augroup fzfstatusline
    autocmd! FileType fzf
    autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    autocmd! user Fzfstatusline call <SID>fzf_statusline()
augroup end

" Extra Commands: {{{1
" Unfortunately the bang doesn't move to a new window. TODO
" Opens matches in a split. Appending ! gives an error.
" How do we fix that?
command! -nargs=1 -bang -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen
