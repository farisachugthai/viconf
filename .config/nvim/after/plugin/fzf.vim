" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: March 24, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'fzf.vim')
    finish
endif

if exists('b:did_fzf_conf') || &compatible || v:version < 700
    finish
endif
let b:did_fzf_conf = 1


" General Setup: {{{1
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

let g:fzf_history_dir = expand('$XDG_DATA_HOME') . '/fzf-history'

" FZF Colors: {{{1

" Gruvbox Hard Coded: {{{2

" Mar 21, 2019:
let g:fzf_colors =
\ {  'fg':      ['fg', '#bdae93'],
  \  'bg':      ['bg', '#1d2021'],
  \  'hl':      ['fg', '#83a598'],
  \  'fg+':     ['fg', '#ebdbb2'],
  \  'bg+':     ['bg', '#ec3836'],
  \  'hl+':     ['fg', '#83a598'],
  \  'info':    ['fg', '#fabd2f'],
  \  'prompt':  ['fg', '#fabd1f'],
  \  'pointer': ['fg', '#8ec07c'],
  \  'marker':  ['fg', '#8ec07c'],
  \  'spinner': ['fg', '#8ec07c'],
  \  'header':  ['fg', '#83a598'] }


" Junegunn Provided Defaults: {{{2

" Customize FZF colors to match your color scheme
" What are the default colors if you don't specify this?
" **I think fzf.vim specifies this for us**

" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLiVne', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'border':  ['fg', 'Ignore'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment'] }

" Mappings: {{{1
" Specifically from that repo so I don't get stuff mixed up if I ever take one
" off or something

" Exported fzf <plug> commands.
" For this first one go down to the advanced functions. Eh we can leave it mapped. It uses imap.
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)

" The way I remapped Leader, this actually only works if you do <Space>\
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

" The remainder behave as expected.
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>

" Mapping for selecting different mappings.
" Could add one for insert mode but leader tab is gonna happen so often that we need to use
" something else. Or we could just use \<tab>....hm.
" NOTE: The imap should probably only be invoked using \<tab>
nmap <leader><tab> <Plug>(fzf-maps-n)
omap <leader><tab> <Plug>(fzf-maps-o)
xmap <leader><tab> <Plug>(fzf-maps-x)
imap <leader><tab> <Plug>(fzf-maps-i)

" Advanced customization using autoload functions
inoremap <expr> <C-x><C-k> fzf#vim#complete#word({'left': '15%'})

" Map vim defaults to fzf history commands
noremap <silent> q: <Cmd>History:<CR>
noremap <silent> q/ <Cmd>History/<CR>

" And get the rest of the fzf.vim commands involved.
noremap <silent> <Leader>L        <Cmd>Lines<CR>
noremap <silent> <Leader>ag       <Cmd>Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       <Cmd>Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y<Cmd>Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        <Cmd>Marks<CR>

" If you want help with that, remember that :he fzf and :he fzf-vim give 2
" different docs
" FZF beat fugitive out on this one. Might take git log too.
nnoremap <Leader>gg <Cmd>GGrep<Space>
nnoremap <Leader>gl <Cmd>Commits<CR>
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --all --branches --pretty --format="h%d %s %c(black)%c(bold)%cr"'

noremap <Leader>gs <Cmd>GFiles?<CR>

" Global Line Completion: {{{2

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" Command Local Options: {{{2

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R ./** && ctags -R --append ./.*'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'


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

" Advanced Functions And Commands: {{{1

" Complete Word: {{{2

" This was an autoloaded funcref so name needs to match path
" FZF complete word with prefix added for termux
" function! fzf#vim#complete#word(...)
"     return fzf#vim#complete(s:extend){
"         \ 'source': 'cat $_ROOT/share/dict/words'},
"         \ get(a:000, 0, fzf#wrap())))
" endfunction

inoremap <expr> <c-x><c-k> fzf#complete({
            \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add /usr/share/dict/words 2>/dev/null',
            \ 'options': '--preview=bat {} --ansi --multi --cycle',
\ 'left': 50})

" Grep: {{{2
" Unfortunately the bang doesn't move to a new window. TODO
" Opens matches in a split. Appending ! gives an error.
" How do we fix that?
command! -nargs=1 -bang -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

" GGrep: {{{2
" From fzf-vim.txt
" fzf-vim-advanced-customization
" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Ag: {{{2
" :Ag  - Start fzf with hidden preview window that can be enabled with '?' key
" :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Rg: {{{2
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)

" Files: {{{2
" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Make Sentence: {{{2

" *fzf-vim-reducer-example*

function! s:make_sentence(lines)
    return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

inoremap <expr> <c-x><c-s> fzf#vim#complete({
    \ 'source':  'cat /usr/share/dict/words',
    \ 'reducer': function('<sid>make_sentence'),
    \ 'options': '--multi --reverse --margin 15%,0',
    \ 'left':    20})
