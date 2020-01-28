" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Sep 15, 2019
" ============================================================================

" Ensure it actually loaded
if !exists(':FZF') | call plug#load('fzf') | endif
" let g:fzf_command_prefix = 'Fuf'
if !exists(':Rg') | call plug#load('fzf.vim') | endif

" Set up windows to have the correct commands
if !exists('$FZF_DEFAULT_COMMAND')  || !has('unix')
  " let $FZF_DEFAULT_COMMAND = 'rg --hidden -M 200 -m 200 --smart-case --passthru --files . '
  let $FZF_DEFAULT_COMMAND = 'fd -H --follow -d 6 --color always -t f '
endif

let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" NOTE: Use of stdpath() requires nvim0.3>
let g:fzf_history_dir = stdpath('data') . '/site/fzf-history'

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

" NOTE: This has to remain the name of the augroup it's what Junegunn calls
augroup FZFStatusline
  au!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

noremap <F6>                <Cmd>Snippets<CR>
noremap! <F6>               <Cmd>Snippets<CR>
" I suppose for continuity
tnoremap <F6>               <Cmd>Snippets<CR>

" All <C-x> mappings
  if has('unix')
    if executable('ag')
      imap <C-x><C-f> <Plug>(fzf-complete-file-ag)
      imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
    else
      imap <C-x><C-f> <Plug>(fzf-complete-file)
      imap <C-x><C-j> <Plug>(fzf-complete-path)
    endif
  else
      imap <C-x><C-f>       <Plug>(fzf-complete-file)
      imap <C-x><C-j>       <Plug>(fzf-complete-path)
      inoremap <C-f>        <C-x><C-f>
      inoremap <C-j>        <C-x><C-j>
  endif

  inoremap <expr> <C-x><C-l> fzf#vim#complete#line()
  inoremap <expr> <C-l>      fzf#vim#complete#line()

  " Uhhh C-b for buffer?
  inoremap <expr> <C-x><C-b> fzf#vim#complete#buffer_line()

  imap <expr> <C-x><C-s>    fzf#vim#complete#word({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    40})
  " And add a shorter version
  inoremap <C-s>            <C-x><C-s>
  imap <expr> <C-x><C-k>    fzf#complete({
              \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
              \ 'options': '-ansi --multi --cycle', 'left': 30})
  inoremap <C-k>            <C-x><C-k>

" NOTE: The imap should probably only be invoked using \<tab>
nmap ,<tab>                 <Plug>(fzf-maps-n)
omap ,<tab>                 <Plug>(fzf-maps-o)
xmap ,<tab>                 <Plug>(fzf-maps-x)
imap ,<tab>                 <Plug>(fzf-maps-i)

" Map vim defaults to fzf history commands
nnoremap <silent> q:        <Cmd>History:<CR>
nnoremap <silent> q/        <Cmd>History/<CR>

" And get the rest of the fzf.vim commands involved.
nnoremap  <Leader>l         <Cmd>Lines<CR>
nnoremap  <Leader>s         <Cmd>Ag <C-R><C-W><CR>
nnoremap  <Leader>s         <Cmd>Ag <C-R><C-A><CR>
xnoremap  <Leader>s         y<Cmd>Ag <C-R>"<CR>
nnoremap  <Leader>`         <Cmd>Marks<CR>

" FZF beat fugitive out on this one. Might take git log too.
nnoremap <Leader>gg         <Cmd>GGrep<Space>
nnoremap <Leader>gl         <Cmd>Commits<CR>
nnoremap <Leader>g?         <Cmd>GFiles?<CR>

" NERDTree Mapping: Dude I forgot I had this. Make sure :Files works but this
" mapping is amazing.
nnoremap <expr> <Leader>n   (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

nnoremap ,b                 <Cmd>Buffers<CR>
nnoremap ,B                 <Cmd>Buffers<CR>

" FZGrep:
  " here's the call signature for fzf#vim#grep
  " - fzf#vim#grep(command, with_column, [options], [fullscreen])
  "   If you're interested it would be kinda neat to modify that `dir` line

command! -complete=file_in_path -nargs=? -bang -bar FZGrep call fzf#run(fzf#wrap('grep', {
      \ 'source': 'silent! grep! <q-args>',
      \ 'sink': 'edit',
      \ 'options': ['--multi', '--ansi', '--border'],}))
      \ <bang>0 ? fzf#vim#with_preview('up:60%')  : fzf#vim#with_preview('right:50%:hidden', '?')

	" -addr=buffers		Range for buffers (also not loaded buffers)

  " Gtfo it worked
command! -bang -bar -complete=file -addr=buffers -nargs=* FZGGrep
  \   call fzf#vim#grep(
  \   'git grep --line-number --color=always ' . shellescape(<q-args>),
  \   0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0]},
  \   <bang>0)
" Ag: FZF With a Preview Window {{{2
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -complete=dir -bang -bar -addr=buffers -nargs=* FZPreviewAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: Use `:Rg` or `:FZRg` or `:FufRg` before this one
command! -bar -complete=dir -bang -nargs=* FZMehRg
  \ call fzf#run(fzf#wrap('rg', {
        \   'source': 'rg --no-column --no-line-number --no-heading --no-messages --color=ansi'
        \   . ' --smart-case --follow ' . shellescape(<q-args>),
        \   'sink': 'vsplit',
        \   'options': ['--ansi', '--multi', '--border', '--cycle', '--prompt', 'FZRG:',],},
        \ <bang>0
        \ ))

        " \   <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?')
" Files With Preview Window: {{{2
command! -bang -nargs=? -complete=dir -bar FZPreviewFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" PlugHelp: " Does this need an f-args?
command! -bang -bar FZHelp call fzf#run(fzf#wrap({'help',
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('find_files#plug_help_sink')}, <bang>0))

" Doesnt work
command! -bar -bang -nargs=* -complete=dir FZAgrep call fzf#vim#grep(s:ag_command .
      \ shellescape(<q-args>), 1, <bang>0)

command! -bar -bang -nargs=0 -complete=color FZColors
  \ call fzf#vim#colors({'left': '35%',
  \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" FZBuf: Works better than FZBuffers
command! -bar -bang -complete=buffer FZBuf call fzf#run(fzf#wrap('buffers',
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')},
    \ <bang>0))

" FZBuffers: Use Of g:fzf_options:
  " As of Oct 15, 2019: this works. Also correctly locates files which none of my rg commands seem to do
command! -bang -complete=buffer -bar FZBuffers call fzf#run(fzf#wrap('buffers',
        \ {'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': g:fzf_options,
        \ 'down':    len(find_files#buflist()) + 2
        \ }, <bang>0))

" FZMru: I feel like this could work with complete=history right?
command! -bang -bar FZMru call find_files#FZFMru()

" FZGit:
  " Oct 15, 2019: Works!
  " TODO: The above command should use the fzf funcs
  " and also use this
  " \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
command! -bar -complete=file FZGit call find_files#FZFGit()

" Rg That Updates:
command! -bar -complete=dir -nargs=* -bang FZRg call find_files#RipgrepFzf(<q-args>, <bang>0)

" Doesn't update but i thought i was cool
command! -bar -complete=dir -bang -nargs=* FzRgPrev
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case ' . <q-args>,
  \   1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bar -bang -complete=dir -nargs=* FZLS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))

" only search projects lmao
command! -bar -bang FZProjectFiles call fzf#vim#files('~/projects', <bang>0)

" Or, if you want to override the command with different fzf options, just pass
" a custom spec to the function.
command! -bar -bang -nargs=? -complete=dir FZReverse
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)

" Want a preview window?
command! -bar -bang -nargs=? -complete=dir FZFilePreview
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)

command! -bar -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'source': 'fd -H -t f',
    \ 'options': [
    \ '--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}'
    \ ]}, <bang>0)

" Override his command to add completion
command! -bar -bang -nargs=? -complete=file GFiles call fzf#vim#gitfiles(<q-args>, <bang>0)

" Me just copy pasting his plugin
command! -bar -bang FZIMaps call fzf#vim#maps("i", <bang>0)',
command! -bar -bang FZCMaps call fzf#vim#maps("c", <bang>0)',
command! -bar -bang FZTMaps call fzf#vim#maps("t", <bang>0)',

" command! -bar -nargs=? -complete=mapping FZMaps execute ':Maps <q-args>'

" Vim: set fdm=indent:
