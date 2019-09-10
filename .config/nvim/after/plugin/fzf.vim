" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Jul 09, 2019
" ============================================================================

" Guards: {{{1
if !has_key(plugs, 'fzf.vim') | finish | endif

if empty('g:loaded_fzf') | finish | endif

if exists('g:did_fzf_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_fzf_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Options: {{{1

let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" Apr 16, 2019: I'm gonna move this down a directory into the nvim one
" June 08, 2019: Changing to stdpath so that it goes to the right dir on Windows
let g:fzf_history_dir = stdpath('data') . '/fzf-history'

let g:fzf_layout = { 'window': 'enew' }

let s:ag_command = 'ag --smart-case -u -g " " --'

let s:rg = 'rg --hidden --max-columns=300 --max-depth=8 --max-count=50 --color=ansi --no-column --no-line-number  --no-heading --auto-hybrid-regex --max-columns-preview --no-messages --smart-case '

if has('unix')
  let s:rg = s:rg . ' --path-separator="/" '
else
  let s:rg = s:rg . ' --path-separator="\" '
endif

let s:fzf_options = ['--ansi', '--multi', '--tiebreak=index', '--layout=reverse-list',
  \   '--inline-info', '--prompt', '> ', '--bind=ctrl-s:toggle-sort',
  \   '--header', ':: Press CTRL-S to toggle sort, CTRL-Y to yank commit hashes',
  \   '--expect=ctrl-y', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \ '--border', '--smart-case', '--cycle'
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
" Gruvbox Hard Coded: {{{2

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

" Override Colors command. You can safely do this in your .vimrc as fzf.vim
" will not override existing commands.
command! -bang FZFColors
  \ call fzf#vim#colors({'left': '35%',
  \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" Mappings: {{{1
" Exported fzf <plug> commands.
" For this first one go down to the advanced functions. Eh we can leave it mapped. It uses imap.
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)

" Global line completion (not just open buffers. ripgrep required.)
imap <expr> <C-x><C-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix'  : '^.*$',
  \ 'source'  : s:rg ,
  \ 'options' : s:fzf_options,
  \ 'reducer' : { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

inoremap <C-l> <C-x><C-l>

nnoremap <silent> <expr> <Leader>n (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

noremap <silent> <Leader>C        <Cmd>Colors<CR>
noremap <silent> <Leader><CR>     <Cmd>Buffers<CR>
noremap <Leader>bu                <Cmd>Buffers<CR>
noremap <Leader>bB                <Cmd>Buffers<CR>
noremap <Leader>f                 <Cmd>Files<CR>
inoremap <silent> <C-f>           <C-x><C-f> 

" Make fzf behave the same in a real shell and nvims.
tnoremap <C-t>                    <Cmd>FZF! <CR>

" Mapping for selecting different mappings.
" Could add one for insert mode but leader tab is gonna happen so often that we need to use
" something else. Or we could just use \<tab>....hm.
" NOTE: The imap should probably only be invoked using \<tab>
nmap <Leader><tab>                 <Plug>(fzf-maps-n)
omap <Leader><tab>                 <Plug>(fzf-maps-o)
xmap <Leader><tab>                 <Plug>(fzf-maps-x)
imap <Leader><tab>                 <Plug>(fzf-maps-i)

" Advanced customization using autoload functions
inoremap <expr> <C-x><C-k>         fzf#vim#complete#word({'left': '45%'})

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

" Custom FZF Statusline Function: {{{1

augroup fzfstatusline
    autocmd! FileType fzf
    autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    autocmd FileType fzf call find_files#fzf_statusline()
    \| autocmd BufLeave <buffer> unlet &statusline && runtime plugin/stl.vim
augroup end

if filereadable('/usr/share/dict/words')
  call find_files#fzf_maps()
endif

" Grepprg And Find: {{{1

" Completion behavior				*:command-completion* *E179*
" ...
" -complete=file_in_path	file and directory names in |'path'|
" So that this command behaves similarly to the built in find.
command! -bang -nargs=* -complete=file_in_path Find
      \ call fzf#vim#grep(
      \ 'rg --no-heading --smart-case --no-messages ^ '
      \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0)

" Grep: {{{1
command! -nargs=? -bang -bar Grep fzf#run(fzf#wrap({
      \ 'source': 'silent! grep! <q-args>',
      \ 'options': ['--multi', '--ansi', '--border'],
      \ <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0})


" GGrep: {{{1
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
"   If you're interested it would be kinda neat to modify that `dir` line
"   so that it was formatted to accept fzf options
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number --color=always ' . shellescape(<q-args>),
  \   0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0]},
  \   <bang>0)

" Ag: {{{1

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
command! -complete=dir -bang -nargs=* YourAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: {{{1


" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
" So officially I think this works better than the original!

" Doesnt work anymore
command! -complete=dir -bang -nargs=* YourRg
  \ call fzf#vim#grep(
  \   'rg --no-column --no-line-number --no-heading --no-messages --color=always'
  \ . ' --smart-case --ansi --multi --border --cycle ' . shellescape(<q-args>),
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"  Files command with preview window: {{{1
command! -bang -nargs=? -complete=dir YourFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Example Of Reducer: {{{1

if filereadable('/usr/share/dict/words') 
  call find_files#fzf_spell()
endif

if filereadable(expand($_ROOT) . '/share/dict/words')
  call find_files#fzf_dict()
endif

" PlugHelp: {{{1
" Does this need an f-args?
command! -bang -bar YourHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('find_files#plug_help_sink')}, <bang>0))

" YourAg: {{{1

" Doesnt work
command! -bang -nargs=* -complete=dir YourGrepAg call fzf#vim#grep(s:ag_command .
      \ shellescape(<q-args>), 1, <bang>0)

" FBuf: {{{1
" Dude he not only wrote this command, he put 4 different versions in the
" docs like jesus christ

command! -bang Buffers call fzf#run(fzf#wrap('buffers',
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}, <bang>0))


" FZFBuffers FZFMRU FZFGit: {{{1

" TODO: Make options a list
command! -bang -complete=buffer -bar FZFBuffers call fzf#run(fzf#wrap({
        \ 'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': '+m --query --prompt "Buffers" ',
        \ 'down':    len(find_files#buflist()) + 2
        \ }, <bang>0)

command! -bang -bar FzfMru call find_files#FZFMru()

command! -bang -bar FzfGit call find_files#FZFGit()

  " TODO: The above command should use the fzf funcs 
  " and also use this
  " \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
