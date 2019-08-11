" ============================================================================
    " File: fzf.vim
    " Author: Faris Chugthai
    " Description: FZF configuration
    " Last Modified: Jul 09, 2019
" ============================================================================

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

" FZF Colors: {{{1

" Gruvbox Hard Coded: {{{2

" Mar 21, 2019:
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
command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

" Mappings: {{{1
" Exported fzf <plug> commands.
" For this first one go down to the advanced functions. Eh we can leave it mapped. It uses imap.
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
" imap <C-x><C-l> <Plug>(fzf-complete-line)

imap <C-k> <Plug>(fzf-complete-word)
imap <C-f> <Plug>(fzf-complete-path)
imap <C-j> <Plug>(fzf-complete-file-ag)

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

" Mapping for selecting different mappings.
" Could add one for insert mode but leader tab is gonna happen so often that we need to use
" something else. Or we could just use \<tab>....hm.
" NOTE: The imap should probably only be invoked using \<tab>
nmap <Leader><tab>                 <Plug>(fzf-maps-n)
omap <Leader><tab>                 <Plug>(fzf-maps-o)
xmap <Leader><tab>                 <Plug>(fzf-maps-x)
imap <Leader><tab>                 <Plug>(fzf-maps-i)

" Advanced customization using autoload functions
inoremap <expr> <C-x><C-k> fzf#vim#complete#word({'left': '15%'})

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
augroup end

if filereadable('/usr/share/dict/words')
  call find_files#fzf_maps()
endif

" Complete Word: {{{1

" This was an autoloaded funcref so name needs to match path
" FZF complete word with prefix added for termux
" function! fzf#vim#complete#word(...)
"     return fzf#vim#complete(s:extend){
"         \ 'source': 'cat $_ROOT/share/dict/words'},
"         \ get(a:000, 0, fzf#wrap())))
" endfunction

if exists($_ROOT)
  if filereadable(expand($_ROOT) . '/share/dict/words')
    inoremap <expr> <C-x><C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': ' --ansi --multi --cycle', 'left': 30})

    inoremap <expr> <C-k> fzf#complete({
                \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
                \ 'options': ' --ansi --multi --cycle', 'left': 30})
  endif
endif

" Grepprg And Find: {{{2

" command! -bang -nargs=* Find
"       \ call fzf#vim#grep(
"       \ 'rg --no-heading --smart-case --no-ignore ^ ', 1,
"       \ . shellescape(<q-args>), <bang>0 ? fzf#vim#with_preview('up:60%')
"       \ : fzf#vim#with_preview('right:50%:hidden', '?'),
"       \ <bang>0)

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
" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], [preview window], [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* YourAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: {{{2
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
" So officially I think this works better than the original!
command! -bang -nargs=* YourRg
  \ call fzf#vim#grep(
  \   'rg --no-column --no-line-number --no-heading --no-messages --color=always --smart-case . ', 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Make Sentence: {{{2

if filereadable('/usr/share/dict/words')

  " *fzf-vim-reducer-example*
  function! s:make_sentence(lines) abort
      return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
  endfunction

  inoremap <expr> <C-x><C-s> fzf#vim#complete({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    20})

  " And add a shorter version
  inoremap <expr> <C-s> fzf#vim#complete({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    20})

endif

" PlugHelp: {{{1
" Does this need an f-args?
command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink'  :   function('find_files#plug_help_sink')}))

" F: {{{1

let g:ag_command = 'ag --smart-case -u -g " " --'

command! -bang -nargs=* F call fzf#vim#grep(g:ag_command .shellescape(<q-args>), 1, <bang>0)

" FZFBuffers FZFMRU FZFGit: {{{1

command! FZFBuffers call fzf#run({
        \ 'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': '+m',
        \ 'down':    len(find_files#buflist()) + 2
        \ })

command! FZFMru call FZFMru()

command! FZFGit call find_files#FZFGit()

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
