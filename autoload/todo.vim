" ============================================================================
    " File: todo.vim
    " Author: Faris Chugthai
    " Description: Todo grep
    " Last Modified: Aug 24, 2019
" ============================================================================

function! todo#Todo() abort  " {{{
" Grep for todos in the current repo and populate the quickfix list with them.
" You could run an if then to check you're in a git repo.
" Also could use ag/rg/fd and fzf instead of grep to supercharge this.

  let entries = []
  for cmd in ['git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null',
              \ 'grep -rniI -e TODO -e todo -e FIXME -e XXX -e HACK * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
" }}}

function! todo#fzf() abort  " {{{
  if !exists('b:git_dir') | return | endif

  let s:grep_cmd = 'git grep -niI -e TODO -e todo -e FIXME -e XXX -e HACK 2> /dev/null'
  call fzf#run(fzf#wrap('git-grep', {
        \ 'source' : 's:grep_cmd',
        \ 'sink': 'pedit',
        \ 'dir': 'git rev-parse --show-root',
        \ 'options': ['--ansi', '--multi', '--border', '--prompt', 'FZF Git Grep:', '--reverse'],}))
        " \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden'),
endfunction
" }}}

" ================ Ranger =======================: {{{

if exists('g:ranger_choice_file')
  if empty(glob(g:ranger_choice_file))
    let s:choice_file_path = g:ranger_choice_file
  else
    echom "Message from *Ranger.vim* :"
    echom "You've set the g:ranger_choice_file variable."
    echom "Please use the path for a file that does not already exist."
    echom "Using /tmp/chosenfile for now..."
  endif
endif

if exists('g:ranger_command_override')
  let s:ranger_command = g:ranger_command_override
else
  let s:ranger_command = 'ranger'
endif

if !exists('s:choice_file_path')
  let s:choice_file_path = '/tmp/chosenfile'
endif

function! OpenRangerIn(path, edit_cmd)
  let currentPath = expand(a:path)
  let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }
  function! rangerCallback.on_exit(job_id, code, event)
    if a:code == 0
      silent! Bclose!
    endif
    try
      if filereadable(s:choice_file_path)
	for f in readfile(s:choice_file_path)
	  exec self.edit_cmd . f
	endfor
	call delete(s:choice_file_path)
      endif
    endtry
  endfunction
    enew
    if isdirectory(currentPath)
      call termopen(s:ranger_command . ' --choosefiles=' . s:choice_file_path . ' "' . currentPath . '"', rangerCallback)
    else
      call termopen(s:ranger_command . ' --choosefiles=' . s:choice_file_path . ' --selectfile="' . currentPath . '"', rangerCallback)
    endif
    startinsert
  endfunction

command! RangerCurrentFile call OpenRangerIn("%", s:default_edit_cmd)
command! RangerCurrentDirectory call OpenRangerIn("%:p:h", s:default_edit_cmd)
command! RangerWorkingDirectory call OpenRangerIn(".", s:default_edit_cmd)
command! Ranger RangerCurrentFile

" To open the selected file in a new tab
command! RangerCurrentFileNewTab call OpenRangerIn("%", 'tabedit ')
command! RangerCurrentFileExistingOrNewTab call OpenRangerIn("%", 'tab drop ')
command! RangerCurrentDirectoryNewTab call OpenRangerIn("%:p:h", 'tabedit ')
command! RangerCurrentDirectoryExistingOrNewTab call OpenRangerIn("%:p:h", 'tab drop ')
command! RangerWorkingDirectoryNewTab call OpenRangerIn(".", 'tabedit ')
command! RangerWorkingDirectoryExistingOrNewTab call OpenRangerIn(".", 'tab drop ')
command! RangerNewTab RangerCurrentDirectoryNewTab

function! OpenRanger()
  Ranger
endfunction

" Open Ranger in the directory passed by argument
function! OpenRangerOnVimLoadDir(argv_path)
  let s:path = expand(a:argv_path)

  " Delete empty buffer created by vim
  Bclose!

  " Open Ranger
  call OpenRangerIn(path, 'edit')
endfunction

" To open ranger when vim load a directory
if exists('g:ranger_replace_netrw') && g:ranger_replace_netrw
  augroup ReplaceNetrwByRangerVim
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter * if isdirectory(expand("%")) | call OpenRangerOnVimLoadDir("%") | endif
  augroup END
endif

if !exists('g:ranger_map_keys') || g:ranger_map_keys
  map <leader>f :Ranger<CR>
endif
" }}}
