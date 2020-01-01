" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Sep 15, 2019
" ============================================================================

" Ensure it actually loaded
if !exists(':FZF') | call plug#load('fzf') | endif
let g:fzf_command_prefix = 'Fuf'
if !exists(':FufRg') | call plug#load('fzf.vim') | endif

" Set up windows to have the correct commands
if !exists('$FZF_DEFAULT_COMMAND')  || !has('unix')
  " let $FZF_DEFAULT_COMMAND = 'rg --hidden -M 200 -m 200 --smart-case --passthru --files . '
  let $FZF_DEFAULT_COMMAND = 'fd -H --follow -d 6 --color always -t f '
endif

" Idk if this is gonna do anything on WSL but let's see
let g:fzf_launcher = 'xterm -e bash -ic %s'

let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir = stdpath('data') . '/fzf-history'

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
  let g:fzf_layout = { 'window': 'call plugins#FloatingFZF()' }
else
  let g:fzf_layout = { 'window': '-tabnew' }
endif

let g:fzf_ag_options = ' --smart-case -u -g " " --'

" TODO: Might wanna consider turning this into a list
let g:fzf_rg_options = ' --hidden --max-columns 300 --max-depth 8 '
      \. '--max-count 50 --color ansi --context 0 '
      \. ' --auto-hybrid-regex --max-columns-preview --smart-case '
      \. '--glob "!{.git,node_modules,*.txt,*.csv,*.json,*.html}" '


let g:fzf_options = [
      \   '--ansi', '--multi', '--tiebreak=index', '--layout=reverse-list',
      \   '--inline-info', '--prompt', '> ', '--bind=ctrl-s:toggle-sort',
      \   '--header', ' Press CTRL-S to toggle sort, CTRL-Y to yank commit hashes',
      \   '--expect=ctrl-y', '--bind', 'alt-a:select-all,alt-d:deselect-all',
      \   '--border', '--cycle'
      \ ]

if exists('$TMUX')
  let g:fzf_prefer_tmux = 1
endif

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = ' --graph'
      \ . ' --color=always --all --branches --pretty'
      \ . ' --format="h%d %s $* " '

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
      " \ . '--options='
"       \ . expand('~')
"       \ . '/projects/dynamic_ipython/tools/ctagsOptions.cnf'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" FOUND ONE
" let g:fzf_files_options = g:fzf_options
" found another one. What is this???
" nnoremap <plug>(-fzf-vim-do) :execute g:__fzf_command<cr>

let g:fzf_colors =  {
      \  'fg':      ['fg', '#fbf1c7'],
      \  'bg':      ['bg', '#1d2021'],
      \  'hl':      ['fg', '#83a598'],
      \  'fg+':     ['fg', '#ec3836', '#3c3836', '#ebdbb2'],
      \  'bg+':     ['bg', '#ec3836', '#3c3836'],
      \  'hl+':     ['fg', '#fb4934'],
      \  'border':  ['fg', 'Ignore'],
      \  'info':    ['fg', '#fabd2f'],
      \  'prompt':  ['fg', '#fe8019'],
      \  'pointer': ['fg', '#fb4934'],
      \  'marker':  ['fg', '#fb4934'],
      \  'spinner': ['fg', '#b8bb26'],
      \  'header':  ['fg', '#83a598']
      \ }

function! s:fzf_statusline()
  " Override statusline as you like
  hi! fzf1 cterm=bold,underline,reverse gui=bold,underline,reverse guifg=#7daea3
  hi! link fzf2 fzf1
  hi! link fzf3 fzf1
  setlocal statusline=%#fzf1#\ FZF:\ %#fzf2#fz%#fzf3#f
endfunction

augroup FZFStatusline
  au!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" hi! fzf1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656 cterm=bold,underline guisp=NONE gui=bold,underline
" hi! fzf2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656 cterm=bold,underline guisp=NONE gui=bold,underline
" hi! fzf3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656 cterm=bold,underline guisp=NONE gui=bold,underline

noremap <F6> <Cmd>FufSnippets<CR>
noremap! <F6> <Cmd>FufSnippets<CR>
" I suppose for continuity
tnoremap <F6> <Cmd>FufSnippets<CR>


" If you have executable('ag') then don't ever use fzf-complete-path or file!
" actually shit doesn't work otherwise on windows :/
if has('unix')
  if executable('ag')
    imap <C-x><C-f> <Plug>(fzf-complete-file-ag)
    imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
  else
    imap <C-x><C-f> <Plug>(fzf-complete-file)
    imap <C-x><C-j> <Plug>(fzf-complete-path)
  endif
else
    imap <C-x><C-f> <Plug>(fzf-complete-file)
    imap <C-x><C-j> <Plug>(fzf-complete-path)
    inoremap <C-f> <C-x><C-f>
    inoremap <C-j> <C-x><C-j>
endif

" Holy shit this works well
inoremap <expr> <C-x><C-l> fzf#vim#complete#line()
inoremap <expr> <C-l> fzf#vim#complete#line()

" Uhhh C-b for buffer?
inoremap <expr> <C-x><C-b> fzf#vim#complete#buffer_line()

if filereadable(expand('$_ROOT/share/dict/words'))
  call find_files#fzf_maps()

  " Note: This is dependant on /usr/share/dict/words existing because this
  " function implicitly depends on it.
  inoremap <expr> <C-x><C-k>         fzf#vim#complete#word({'left': '45%'})

else
" dictionary isn't set on windows
  imap <C-x><C-k> <C-x><C-u>
  " Supertab should've made that mapping pretty sweet.
  " In addition the stub at `:he i_CTRL_K` said that it's used for inserting
  " digraphs like fuck that
  inoremap <C-k> <C-x><C-k>
endif

" NOTE: The imap should probably only be invoked using \<tab>
nmap <Leader><tab>                 <Plug>(fzf-maps-n)
omap <Leader><tab>                 <Plug>(fzf-maps-o)
xmap <Leader><tab>                 <Plug>(fzf-maps-x)
imap <Leader><tab>                 <Plug>(fzf-maps-i)

" Map vim defaults to fzf history commands
nnoremap <silent> q:                <Cmd>FufHistory:<CR>
nnoremap <silent> q/                <Cmd>FufHistory/<CR>

" And get the rest of the fzf.vim commands involved.
nnoremap <silent> <Leader>L         <Cmd>FufLines<CR>
nnoremap <silent> <Leader>ag        <Cmd>FufAg <C-R><C-W><CR>
noremap <silent> <Leader>AG        <Cmd>FufAg <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y<Cmd>FufAg <C-R>"<CR>
nnoremap <silent> <Leader>`        <Cmd>FufMarks<CR>

" FZF beat fugitive out on this one. Might take git log too.
nnoremap <Leader>gg                 <Cmd>FufGGrep<Space>
nnoremap <Leader>gl                 <Cmd>FufCommits<CR>
nnoremap <Leader>GS                 <Cmd>FufGFiles?<CR>

" NERDTree Mapping: Dude I forgot I had this. Make sure :Files works but this
" mapping is amazing.
nnoremap <silent><expr> <Leader>n (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

nnoremap <silent> <Leader>C        <Cmd>FufColors<CR>
nnoremap <silent> <Leader><CR>     <Cmd>FufBuffers<CR>
nnoremap <Leader>bu                <Cmd>FufBuffers<CR>
nnoremap <Leader>B                 <Cmd>FufBuffers<CR>
nnoremap <Leader>f                 <Cmd>FufFiles<CR>

" Make fzf behave the same in a real shell and nvims. FZF now runs in a terminal
" So making it a tmap creates recursive instances which behaves oddly
" tnoremap <C-t>                    <Cmd>FZF!<CR>

" here's the call signature for fzf#vim#grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
"   If you're interested it would be kinda neat to modify that `dir` line
"   so that it was formatted to accept fzf options
" NOTE: It doesn't take a dictionary so stop doing that

" Completion behavior				*:command-completion* *E179*
" -complete=file_in_path	file and directory names in |'path'|
" So that this command behaves similarly to the built in find.
command! -nargs=? -bang -bar FZGrep fzf#run(fzf#wrap('grep', {
      \ 'source': 'silent! grep! <q-args>',
      \ 'sink': 'edit',
      \ 'options': ['--multi', '--ansi', '--border'],
      \ <bang>0 ? fzf#vim#with_preview('up:60%')  : fzf#vim#with_preview('right:50%:hidden', '?')}))


" GGrep: {{{2
command! -bang -nargs=* FZGGrep
  \   call fzf#vim#grep(
  \   'git grep --line-number --color=always ' . shellescape(<q-args>),
  \   0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0]},
  \   <bang>0)

" Ag: FZF With a Preview Window {{{2

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
command! -complete=dir -bang -nargs=* FZPreviewAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: {{{2
command! -complete=dir -bang -nargs=* FZRg
  \ call fzf#run(fzf#wrap('rg', {
  \   'source': 'rg --no-column --no-line-number --no-heading --no-messages --color=always'
  \   . ' --smart-case ' . shellescape(<q-args>),
  \   'sink': 'vsplit',
  \   'options': ['--ansi', '--multi', '--border', '--cycle'],}))
  " \   <bang>0 ? fzf#vim#with_preview('up:60%')
  " \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  " \   <bang>0))

" Files With Preview Window: {{{2
command! -bang -nargs=? -complete=dir FZPreviewFiles
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
command! -bang -nargs=0 -complete=color FZColors
  \ call fzf#vim#colors({'left': '35%',
  \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" FZBuffers: {{{2

" Dude he not only wrote this command, he put 4 different versions in the
" docs like jesus christ
"
command! -complete=buffer -bang FZBuf call fzf#run(fzf#wrap('buffers',
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')}, <bang>0))

" Use Of g:fzf_options: {{{3
"
" As  of Oct 15, 2019: this works
command! -bang -complete=buffer -bar FZBuffers call fzf#run(fzf#wrap('buffers',
        \ {'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': g:fzf_options,
        \ 'down':    len(find_files#buflist()) + 2
        \ }, <bang>0))

" FZMru: {{{2
command! -bang -bar FZMru call find_files#FZFMru()

" FZGit: {{{2
" Oct 15, 2019: Works!
command! -complete=file FZGit call find_files#FZFGit()

" TODO: The above command should use the fzf funcs
" and also use this
" \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
"

" Rg That Updates: {{{2
command! -nargs=* -bang FZRG call find_files#RipgrepFzf(<q-args>, <bang>0)

" Doesn't update but i thought i was cool
command! -complete=dir -bang -nargs=* FzRgPrev
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.<q-args>, 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" New help docs: {{{1

" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
command! -bang -complete=dir -nargs=* FZLS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))

" only search projects lmao
command! -bang ProjectFiles call fzf#vim#files('~/projects', <bang>0)

" Or, if you want to override the command with different fzf options, just pass
" a custom spec to the function.
command! -bang -nargs=? -complete=dir FZReverse
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)

" Want a preview window?
command! -bang -nargs=? -complete=dir FZFilePreview
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)

" It kind of works, but you probably want a nicer previewer program than `cat`.
" fzf.vim ships {a versatile preview script}{11} you can readily use. It
" internally executes {bat}{12} for syntax highlighting, so make sure to install
" it.

" Ill allow this guy to take files back
" oh man does that work better with fdq
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'source': 'fd -H -t f',
    \ 'options': [
    \ '--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}'
    \ ]}, <bang>0)
