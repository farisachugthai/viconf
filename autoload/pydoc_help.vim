" ============================================================================
  " File: pydoc_help
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with help buffers
  " Last Modified: Oct 20, 2019
" ============================================================================

" Honestly most of these functions are in varying states of F'ed up.
" Need to tear this apart and fgure out what works and why.

function! s:temp_buffer() abort  " {{{1

  if exists(':StripWhitespace')
    exec ':StripWhitespace'
  endif

  hi! link Whitespace NONE
  setlocal relativenumber
  setlocal filetype=rst
  " Because i have it on in my rst filetype.
  setlocal nospell
  setlocal nomodified
  setlocal buflisted
  silent setlocal nomodifiable

endfunction
function! pydoc_help#PydocCword() abort  " {{{1

  " Holy shit it works!!!
  let s:temp_cword = expand('<cWORD>')
  enew
  exec ':r! pydoc ' . s:temp_cword
  " If you wanna keep going we can change the status line. We can change how
  " we invoke python
  call s:temp_buffer()

endfunction
function! pydoc_help#SplitPydocCword() abort  " {{{1
  let s:temp_cword = expand('<cWORD>')
  split
  enew
  exec ':r! pydoc ' . s:temp_cword
  call s:temp_buffer()
endfunction
function! pydoc_help#PydocCwordNatively() abort  " {{{1

  " Created because pydoc isn't immediately aware of 3rd party libraries.
  " The above work just fine with the stdlib.
  " However...I don't want to have to make the distinction ya know.
    let s:temp_cword = expand('<cWORD>')
py3 << EOF

import pydoc
import importlib
try:
    helped_mod = importlib.import_module(s:temp_cword)
except:
    vim.command("echoerr 'Error during import of %s'" % s:temp_cword)
else:
    pydoc.help(helped_mod)

EOF
endfunction
function s:handle_user_config() abort   " {{{1

  " Look at me handling user configured arguments!
  if exists('g:pydoc_window')
    if type('g:pydoc_window') == v:t_string
      exec g:pydoc_window
    else
      throw '/autoload/pydoc_help:'
            \ . ' g:pydoc_window needs to be one of "split" "vsplit" or "tabe"'
    endif
  else
    split
  endif

endfunction
function! pydoc_help#Pydoc(module) abort   " {{{1

  " call <SID>handle_user_config()
  enew
  if has('python3')
    " I realize i could do that EOF bullshit but i don't like it.
    if has('unix')
      exec 'r! python3 -m pydoc ' . a:module
    else
      exec 'r! python -m pydoc ' . a:module
      " This func doesn't exist anymore goddamn
      " call s:get_documents(a:module)

    endif

  elseif has('python')  " not sure how to guarantee that python points to py2...
    exec 'r! python -m pydoc ' . a:module
  endif

  call s:temp_buffer()
endfunction
function! pydoc_help#async_cursor() abort " Async Pydoc: {{{1

  call jobstart('pydoc ' . expand('<cWORD>'), {'on_stdout':{j,d,e->append(line('.'),d)}})

endfunction
function! pydoc_help#async_cexpr() abort  " {{{1
  " this function POURS output into the current buf so make sure you're
  " switched to a scratch buffer.
  " However... **THIS WORKS**
	"    <cexpr>    is replaced with the word under the cursor, including more
	"	   to form a C expression.  E.g., when the cursor is on "arg"
	"	   of "ptr->arg" then the result is "ptr->arg"; when the
	"	   cursor is on "]" of "list[idx]" then the result is
	"	   "list[idx]".  This is used for |v:beval_text|.

  call jobstart('pydoc ' . expand('<cexpr>'), {'on_stdout':{j,d,e->append(line('.'),d)}})
endfunction
function! pydoc_help#broken_scratch_buffer() abort  " {{{1
  " Not actually broken i just need to debug the commented out lines
  " basically how do i put the info i want into a list that can be properly
  " parsed by this API

  " From he api-floatwin. Only new versions of Nvim (maybe 0.4+ only?)
  let buf = nvim_create_buf(v:false, v:true)

  " and the help for that function
" nvim_create_buf({listed}, {scratch})                       *nvim_create_buf()*
"                 Creates a new, empty, unnamed buffer.

"                 Parameters: ~
"                     {listed}   Sets 'buflisted'
"                     {scratch}  Creates a "throwaway" |scratch-buffer| for
"                                temporary work (always 'nomodified')


  " original: should fill with pydoc output
  " TODO: this is the "broken" line
  " call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])

  let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
      \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}

  let win = nvim_open_win(buf, 0, opts)
  " optional: change highlight, otherwise Pmenu is used
  call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

  " To close the float, |nvim_win_close()| can be used.
  " 0 for the current window, v:false is for don't force
  nnoremap <buffer> q <Cmd>nvim_win_close(0, v:false)<CR>

endfunction
function! pydoc_help#the_curse_of_nvims_floating_wins() abort  " {{{1
  " No seriously they're difficult to work with

  let s:opts = {
        \ 'relative': 'cursor',
        \ 'width': 10,
        \ 'height': 2,
        \ 'col': 0,
        \ 'row': 1,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ 'focusable': v:true
        \ }

  let s:win_handle = nvim_open_win(bufnr('%'), 0, s:opts)
  let floating_winnr  = nvim_win_get_number(s:win_handle)
  " So now we finally have a winnr which we can work with in a more reasonable
  " fashion. Sweet!!
  call nvim_win_set_option(s:win_handle, 'winhl', 'Special')
endfunction
function! s:ReplaceModuleAlias()  " {{{1 Replace module aliases with their own name.
    "
    " For example:
    "   import foo as bar
    " if `bar` is in the ExpandModulePath's return value, it should be
    " replaced with `foo`.
    let l:cur_col = col(".")
    let l:cur_line = line(".")
    let l:module_path = s:ExpandModulePath()
    let l:module_names = split(l:module_path, '\.')
    let l:module_orig_name = l:module_names[0]
    if search('import \+[0-9a-zA-Z_.]\+ \+as \+' . l:module_orig_name)
        let l:line = getline(".")
        let l:name = matchlist(l:line, 'import \+\([a-zA-Z0-9_.]\+\) \+as')[1]
        if l:name != ''
            let l:module_orig_name = l:name
        endif
    endif
    if l:module_names[0] != l:module_orig_name
        let l:module_names[0] = l:module_orig_name
    endif
    call cursor(l:cur_line, l:cur_col)
    return join(l:module_names, ".")
endfunction
function! s:ExpandModulePath()  " {{{1
    " Extract the 'word' at the cursor, expanding leftwards across identifiers
    " and the . operator, and rightwards across the identifier only.
    "
    " For example:
    "   import xml.dom.minidom
    "           ^   !
    "
    " With the cursor at ^ this returns 'xml'; at ! it returns 'xml.dom'.
    let l:line = getline(".")
    let l:pre = l:line[:col(".") - 1]
    let l:suf = l:line[col("."):]
    return matchstr(pre, "[A-Za-z0-9_.]*$") . matchstr(suf, "^[A-Za-z0-9_]*")
endfunction
function! pydoc_help#show() "{{{
    let word = s:ReplaceModuleAlias()
    let buf = nvim_create_buf(v:false, v:true)
    " not yet
    call s:temp_buffer()
    call jobstart('pydoc ' . word, {'on_stdout':{j,d,e->append(line('.'),d)}})
    setlocal nomodifiable
    setlocal nomodified
    setlocal filetype=rst
    " Make it vertical
    wincmd L
    normal gg
    wincmd p

endfunction "}}}
