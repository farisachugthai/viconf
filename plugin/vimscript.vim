" ============================================================================
  " File: vimscript.vim
  " Author: Faris Chugthai
  " Description: Profiling commands and other
  " Last Modified: Aug 12, 2019
" ============================================================================

" I would say this is unrelated but this file is aimless
nnoremap <Leader>cd <Cmd>cd %:p:h<CR><Bar><Cmd>pwd<CR>

" Fix up the path a little I'm starting to use ]i and gf and the like more
" But make it conditional on me not having already set it for an ftplugin
if !exists('b:did_ftplugin')
  if exists('*stdpath')  " fuckin vim
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'  . ',' . stdpath('config')
  else
    let &path = '.,,**,' . expand('$VIMRUNTIME') . '/*/*.vim'
  endif
endif

" In which I learn hwo complete works
command! -bar -complete=buffer -nargs=0 ScratchBuffer call pydoc_help#scratch_buffer()
command! -bar -complete=compiler Compiler :<C-u>compiler<CR>
" '<,'>s/compiler/event/g
" You may find that ---^ does you good
command! -bar -complete=event Event :<C-u>event<CR>

command! -bar -nargs=0 Redo call histget('cmd', -1)

" Completes filenames from the directories specified in the 'path' option:
command! -nargs=1 -bang -complete=customlist,unix#EditFileComplete
   	\ EF edit<bang> <args>

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

" Commands from the help pages. map.txt
   " Replace a range with the contents of a file
   " (Enter this all as one line)
   command! -bar -range -nargs=1 -complete=file Replace <line1>-pu_|<line1>,<line2>d|r <args>|<line1>d

   " Count the number of lines in the range
   command! -bar -range -nargs=0 Lines  echo <line2> - <line1> + 1 'lines'

" Last Call For Options: {{{1
if &omnifunc ==# '' | setlocal omnifunc=syntaxcomplete#Complete | endif
if &completefunc ==# '' | setlocal completefunc=syntaxcomplete#Complete | endif

if &formatexpr ==# ''
  setlocal formatexpr=format#Format()  " check the autoload directory
endif

" QuickFix: {{{2
" From :he *:cadde* *:caddexpr*
" Evaluate {expr} and add the resulting lines to the current quickfix list.
" If a quickfix list is not present, then a new list is created. The current
" cursor position will not be changed. See |:cexpr| for more information.
" g/mypattern/caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")
" command! -nargs=? QFSearch execute 'g/' . shellescape(<q-args>) . '/ caddexpr ' . expand('%') . ":" . line(".") . ":" . getline(".")
" Doesn't work and tried like 20 times to debug it.

command! -bar -bang -complete=buffer -complete=file -nargs=? Profile call vimscript#profile(<f-args>)
