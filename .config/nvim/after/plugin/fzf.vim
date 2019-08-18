" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Jul 09, 2019
" ============================================================================

" TODO: Come up with a s:rg_command becausevthe implementation here is inconsistent

" Guards: {{{1
if !has_key(plugs, 'fzf.vim')
    finish
endif

if exists('g:did_fzf_after_plugin') || &compatible || v:version < 700
    finish
endif
let g:did_fzf_after_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" General Setup: {{{1

let g:fzf_action = {
  \ 'ctrl-q': function('find_files#build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" Apr 16, 2019: I'm gonna move this down a directory into the nvim one
" June 08, 2019: Changing to stdpath so that it goes to the right dir on Windows
let g:fzf_history_dir = stdpath('data') . '/fzf-history'

let g:fzf_layout = { 'window': 'enew' }

" FZF Colors: {{{1

" Gruvbox Hard Coded: {{{2

let g:fzf_colors =
\ {  'fg':      ['fg', '#fbf1c7'],
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
  \  'header':  ['fg', '#83a598'] }

    " Override Colors command. You can safely do this in your .vimrc as fzf.vim
    " will not override existing commands.
command! -bang FZFColors
  \ call fzf#vim#colors({'left': '35%', 'options': '--reverse --margin 30%,0'}, <bang>0)

" Mappings: {{{1
" Exported fzf <plug> commands.
" For this first one go down to the advanced functions. Eh we can leave it mapped. It uses imap.
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)

" Global line completion (not just open buffers. ripgrep required.)
imap <expr> <C-x><C-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

inoremap <C-l> <C-x><C-l>

" The way I remapped Leader, this basically evaluates to \\ lol
nnoremap <silent> <expr> \<Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

" The remainder behave as expected.
noremap <silent> <Leader>C        <Cmd>Colors<CR>
noremap <silent> <Leader><CR>     <Cmd>Buffers<CR>
noremap <Leader>bu                <Cmd>Buffers<CR>
noremap <Leader>bB                <Cmd>Buffers<CR>
noremap <Leader>f                 <Cmd>Files<CR>
noremap <silent> <C-x><C-f>       <Cmd>Files<CR>
noremap! <silent> <C-x><C-f>      <Cmd>Files<CR>
tnoremap <silent> <C-x><C-f>      <Cmd>Files<CR>

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

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = ' --graph'
      \ . ' --color=always --all --branches --pretty'
      \ . ' --format="h%d %s $*n"'

noremap <Leader>GS <Cmd>GFiles?<CR>

cabbrev GS GFiles?

" Command Local Options: {{{2

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R --options='
      \ . expand('~')
      \ . '/projects/dynamic_ipython/tools/ctagsOptions.cnf'

" [Commands] --expect expression for directly executing the command
" let g:fzf_commands_expect = 'alt-enter,ctrl-x'


" Custom FZF Statusline Function: {{{1

augroup fzfstatusline
    autocmd! FileType fzf
    autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    autocmd! FileType fzf call find_files#fzf_statusline()
    " Holy hell this worked perfectly!
    autocmd! BufLeave if &ft==fzf | unlet &statusline && runtime plugin/stl.vim | endif
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
      \ 'rg --no-heading --smart-case --no--messages ^ '
      \ . shellescape(<q-args>), 1, <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0)

" Grep: {{{1
" Unfortunately the bang doesn't move to a new window. TODO
" Opens matches in a split. Appending ! gives an error.
" How do we fix that?
command! -nargs=1 -bang -bar Grep fzf#run(fzf#wrap({
      \ 'source': 'silent! grep! <q-args>',
      \ 'options': ['--multi', '--ansi', '--border'],
      \ <bang>0 ? fzf#vim#with_preview('up:60%')
      \ : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0})


" GGrep: {{{1
" From fzf-vim.txt
" fzf-vim-advanced-customization
" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

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
command! -complete=dir -bang -nargs=* YourRg
  \ call fzf#vim#grep(
  \   'rg --no-column --no-line-number --no-heading --no-messages --color=always'
  \ . ' --smart-case --ansi --multi --border --cycle ' . shellescape(<qargs>), , 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"  Files command with preview window: {{{1
command! -bang -nargs=? -complete=dir YourFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Example Of Reducer: {{{1

if filereadable('/usr/share/dict/words')

  " *fzf-vim-reducer-example*
  function! s:make_sentence(lines) abort
    return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
  endfunction

  imap <expr> <C-x><C-s> fzf#vim#complete#word({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    40})

  " And add a shorter version
  inoremap <C-s> <C-x><C-s>
  
  
  imap <expr> <C-x><C-k> fzf#fzf#vim#complete#word({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add'
                \ ' $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': ' --ansi --multi --cycle', 'left': 30})

  inoremap <C-k> <C-x><C-k>

endif

" PlugHelp: {{{1
" Does this need an f-args?
command! -bang -bar YourHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('find_files#plug_help_sink')}, <bang>0))

" YourAg: {{{1

let s:ag_command = 'ag --smart-case -u -g " " --'

command! -bang -nargs=* -complete=dir YourGrepAg call fzf#vim#grep(s:ag_command .
      \ shellescape(<q-args>), 1, <bang>0)

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
