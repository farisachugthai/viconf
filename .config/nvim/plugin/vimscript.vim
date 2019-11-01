" ============================================================================
  " File: vimscript.vim
  " Author: Faris Chugthai
  " Description: Profiling commands and other
  " Last Modified: Aug 12, 2019
" ============================================================================

" Guard: {{{1
if exists('g:did_better_profiler_vim_plugin') || &compatible || v:version < 700
  finish
endif
let g:did_better_profiler_vim_plugin = 1

let s:cpo_save = &cpoptions
set cpoptions-=C

" Mappings: {{{1

" I would say this is unrelated but this file is aimless
noremap <Leader>cd <Cmd>cd %:p:h<CR><Bar><Cmd>pwd<CR>
" however we need to move mappings above the profiling check dingus
" WHOA THIS MAPPING IS TOO COOL
inoremap <nowait> ( ()<C-G>U<Left>
inoremap <nowait> [ []<C-G>U<Left>
" This one gets horrifically annoying there are so many situations where you
" don't need it
" inoremap <nowait> < <><C-G>U<Left>

" Options: {{{1
if has('+shellslash')
  set shellslash
endif

" Moved out of init because this should only get sourced one time.
" That g:did_better... guard at the top will ensure that we don't
" add these entries to the path multiple times
set path+=**               " Recursively search dirs with :find
let &path = &path . ',' . expand('$VIMRUNTIME')

if exists('*stdpath')  " fuckin vim
  let &path = &path . ',' . stdpath('config')
endif

" Scratch Buffers: {{{1
command! -nargs=0 ScratchBuffer call pydoc_help#scratch_buffer()

" Commands: {{{1
" These 2 commands are for parsing the output of scriptnames though a command
" like :TBrowseScriptnames would probably be easier to work with
command! -nargs=? Scriptnames call vimscript#Scriptnames(<f-args>)
command! -nargs=0 Scriptnamesdict echo vimscript#ScriptnamesDict()

" Useful if you wanna see all available funcs provided by nvim
command! -nargs=0 NvimAPI
      \ new|put =map(filter(api_info().functions,
      \ '!has_key(v:val,''deprecated_since'')'),
      \ 'v:val.name')

" Easier mkdir and cross platform!
command! -complete=dir -nargs=1 Mkdir call mkdir(shellescape('<q-args>'), 'p', '0700')

" Omnifuncs: {{{1

" I just wanted to move this farther back in the queue
if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif

" Formatexpr: {{{1
" Same with this

if &formatexpr ==# ''
  setlocal formatexpr=format#Format()  " check the autoload directory
endif

" QuickFix: {{{1

" From :he *:cadde* *:caddexpr*
" Evaluate {expr} and add the resulting lines to the current quickfix list.
" If a quickfix list is not present, then a new list is created. The current
" cursor position will not be changed. See |:cexpr| for more information.
" g/mypattern/caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")
" command! -nargs=? QFSearch execute 'g/' . shellescape(<q-args>) . '/ caddexpr ' . expand('%') . ":" . line(".") . ":" . getline(".")
" Doesn't work and tried like 20 times to debug it.

" Keep Profiling At End: {{{1
" Because you have this check and it could stop everything else from getting
" defined for no reason
if !has('profile') || !has('reltime')  " timing functionality
  finish
endif

" Aug 02, 2019: So this command still doesn't work as expected; however, it
" doesn't produce an error on run so there's that
command! -bang -complete=buffer -complete=file -nargs=? -range=% Profile call vimscript#profile(<f-args>)

" Atexit: {{{1

let &cpoptions = s:cpo_save
unlet s:cpo_save
