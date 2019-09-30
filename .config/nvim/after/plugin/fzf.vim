" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Sep 15, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'fzf.vim') | finish | endif

if empty('g:loaded_fzf') | finish | endif

if exists('g:did_fzf_after_plugin') || &compatible || v:version < 700
    finish
endif
" let g:did_fzf_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

let g:fzf_command_prefix = 'FZF'

" Sep 15, 2019: Look what i found in stdpath('data') .
" '/plugged/fzf.vim/plugin/fzf.vim' ! There's a statusline option!!! That's
" awesome because there's kinda no reason to have all those autocmds anyway
" TODO: Wait how do we use it tho
" let g:fzf_nvim_statusline =


let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir = stdpath('data') . '/fzf-history'

let g:fzf_layout = { 'window': 'split' }

let s:ag_command = 'ag --smart-case -u -g " " --'

let s:rg = 'rg --hidden --max-columns=300 --max-depth=8 --max-count=50 --color=ansi --no-column --no-line-number  --no-heading --auto-hybrid-regex --max-columns-preview --no-messages --smart-case '

if has('unix')
  let s:rg = s:rg . ' --path-separator="/" '
else
  let s:rg = s:rg . ' --path-separator="\" '
endif

let s:fzf_options = [
      \   '--ansi', '--multi', '--tiebreak=index', '--layout=reverse-list',
      \   '--inline-info', '--prompt', '> ', '--bind=ctrl-s:toggle-sort',
      \   '--header', ' Press CTRL-S to toggle sort, CTRL-Y to yank commit hashes',
      \   '--expect=ctrl-y', '--bind', 'alt-a:select-all,alt-d:deselect-all',
      \   '--border', '--cycle'
      \ ]


" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = ' --graph'
      \ . ' --color=always --all --branches --pretty'
      \ . ' --format="h%d %s $*n"'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R --options='
      \ . expand('~')
      \ . '/projects/dynamic_ipython/tools/ctagsOptions.cnf'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" FZF Colors: {{{1

let g:fzf_colors =  {
      \  'fg':      ['fg', '#fbf1c7'],
      \  'bg':      ['bg', '#1d2021'],
      \  'hl':      ['fg', '#83a598'],
      \  'fg+':     ['fg', '#ebdbb2', '#3c3836'],
      \  'bg+':     ['bg', '#ec3836', '#3c3836'],
      \  'hl+':     ['fg', '#fb4934'],
      \  'info':    ['fg', '#fabd2f'],
      \  'prompt':  ['fg', '#fe8019'],
      \  'pointer': ['fg', '#fb4934'],
      \  'marker':  ['fg', '#fb4934'],
      \  'spinner': ['fg', '#b8bb26'],
      \  'header':  ['fg', '#83a598']
      \ }

" Defaults:
hi! fzf1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656 cterm=bold,underline
hi! fzf2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656 cterm=bold,underline
hi! fzf3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656 cterm=bold,underline

" FZF Complete: {{{1
" Yo check out the source code for this
" if s:is_win
"   inoremap <expr> <plug>(fzf-complete-path)      fzf#vim#complete#path('dir /s/b')
"   inoremap <expr> <plug>(fzf-complete-file)      fzf#vim#complete#path('dir /s/b/a:-d')
" else
"   inoremap <expr> <plug>(fzf-complete-path)      fzf#vim#complete#path("find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'")
"   inoremap <expr> <plug>(fzf-complete-file)      fzf#vim#complete#path("find . -path '*/\.*' -prune -o -type f -print -o -type l -print \| sed 's:^..::'")
" endif
" inoremap <expr> <plug>(fzf-complete-file-ag)     fzf#vim#complete#path('ag -l -g ""')


" If you have executable('ag') then don't ever use dir or find!!!
if executable('ag')
  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-j> <plug>(fzf-complete-file-ag)
else
  imap <C-x><C-f> <plug>(fzf-complete-path)
endif

imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <plug>(fzf-complete-path)
imap <C-x><C-l> <plug>(fzf-complete-line)


if filereadable(expand($_ROOT) . '/share/dict/words')
  call find_files#fzf_dict()
endif

if filereadable('/usr/share/dict/words')
  call find_files#fzf_spell()
  call find_files#fzf_maps()
  " Advanced customization using autoload functions
  " HOWEVER! It should only get remapped if that file exists because it
  " implicitly depends on it
  inoremap <expr> <C-x><C-k>         fzf#vim#complete#word({'left': '45%'})
endif

" Maps: {{{1
" Mapping for selecting different mappings.
" Could add one for insert mode but leader tab is gonna happen so often that we need to use
" something else. Or we could just use \<tab>....hm.
" NOTE: The imap should probably only be invoked using \<tab>
nmap <Leader><tab>                 <Plug>(fzf-maps-n)
omap <Leader><tab>                 <Plug>(fzf-maps-o)
xmap <Leader><tab>                 <Plug>(fzf-maps-x)
imap <Leader><tab>                 <Plug>(fzf-maps-i)

" Map vim defaults to fzf history commands
noremap <silent> q:                <Cmd>History:<CR>
noremap <silent> q/                <Cmd>History/<CR>

" And get the rest of the fzf.vim commands involved.
noremap <silent> <Leader>L         <Cmd>Lines<CR>
noremap <silent> <Leader>ag        <Cmd>Ag <C-R><C-W><CR>
noremap <silent> <Leader>AG        <Cmd>Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y<Cmd>Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        <Cmd>Marks<CR>

" If you want help with that, remember that :he fzf and :he fzf-vim give 2
" different docs

" FZF beat fugitive out on this one. Might take git log too.
noremap <Leader>gg                 <Cmd>GGrep<Space>
noremap <Leader>gl                 <Cmd>Commits<CR>

cabbrev Gl Commits

noremap <Leader>GS <Cmd>GFiles?<CR>

cabbrev GS GFiles?

" Buffers Windows Files: {{{2

nnoremap <silent><expr> <Leader>n (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

noremap <silent> <Leader>C        <Cmd>Colors<CR>
noremap <silent> <Leader><CR>     <Cmd>Buffers<CR>
noremap <Leader>bu                <Cmd>Buffers<CR>
noremap <Leader>bB                <Cmd>Buffers<CR>
noremap <Leader>f                 <Cmd>Files<CR>

" Make fzf behave the same in a real shell and nvims.
tnoremap <C-t>                    <Cmd>FZF! <CR>


" Commands: {{{1

" here's the call signature for fzf#vim#grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
"   If you're interested it would be kinda neat to modify that `dir` line
"   so that it was formatted to accept fzf options
" NOTE: It doesn't take a dictionary so stop doing that

" Find: {{{2

" Completion behavior				*:command-completion* *E179*
" -complete=file_in_path	file and directory names in |'path'|

" So that this command behaves similarly to the built in find.
command! -bang -nargs=* -complete=file_in_path FZFind
      \ call fzf#vim#grep(
      \ 'rg --no-heading --smart-case --no-messages ^ '
      \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0)

" Grep: {{{2
command! -nargs=? -bang -bar FZGrep fzf#run(fzf#wrap({
      \ 'source': 'silent! grep! <q-args>',
      \ 'options': ['--multi', '--ansi', '--border'],
      \ <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0})


" GGrep: {{{2
command! -bang -nargs=* FZGGrep
  \   call fzf#vim#grep(
  \   'git grep --line-number --color=always ' . shellescape(<q-args>),
  \   0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0]},
  \   <bang>0)

" Ag: {{{2

" :Ag  - Start fzf with hidden preview window that can be enabled with '?' key
" :Ag! - Start fzf in fullscreen and display the preview window above
" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], [preview window], [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -complete=dir -bang -nargs=* FZAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: {{{2
command! -complete=dir -bang -nargs=* FZRg
  \ call fzf#vim#grep({
  \   'source': 'rg --no-column --no-line-number --no-heading --no-messages --color=always'
  \   . ' --smart-case ' . shellescape(<q-args>),
  \   'sink': 'vsplit',
  \   'options': ['--ansi', '--multi', '--border', '--cycle'],}
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Files With Preview Window: {{{2
command! -bang -nargs=? -complete=dir YourFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" PlugHelp: {{{2
" Does this need an f-args?
command! -bang -bar FZHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('find_files#plug_help_sink')}, <bang>0))


" Ag Grep: {{{2
" Doesnt work
command! -bang -nargs=* -complete=dir FZAgrep call fzf#vim#grep(s:ag_command .
      \ shellescape(<q-args>), 1, <bang>0)

" Colors: {{{2
" Override Colors command. You can safely do this in your .vimrc as fzf.vim
" will not override existing commands.
command! -bang FZColors
  \ call fzf#vim#colors({'left': '35%',
  \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" FBuf: {{{2
" Dude he not only wrote this command, he put 4 different versions in the
" docs like jesus christ
command! -bang FZBuffers call fzf#run(fzf#wrap('buffers',
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}, <bang>0))


" Use Of s:fzf_options: {{{2
command! -bang -complete=buffer -bar FZBuffers call fzf#run(fzf#wrap({
        \ 'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': s:fzf_options,
        \ 'down':    len(find_files#buflist()) + 2
        \ }, <bang>0))

" FZMru: {{{2
command! -bang -bar FZMru call find_files#FZFMru()

" FZGit: {{{2
command! -bang -bar FZGit call find_files#FZFGit()

  " TODO: The above command should use the fzf funcs 
  " and also use this
  " \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
