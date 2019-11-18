" ============================================================================
  " File: pydoc_help
  " Author: Faris Chugthai
  " Description: Autoloaded functions for working with help buffers
  " Last Modified: Oct 20, 2019
" ============================================================================

" Guards: {{{1
let s:cpo_save = &cpoptions
set cpoptions-=C

" Pydoc Cword: {{{1

function! s:temp_buffer() abort

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

function! pydoc_help#PydocCword() abort

  " Holy shit it works!!!
  let s:temp_cword = expand('<cWORD>')
  enew
  exec ':r! pydoc ' . s:temp_cword
  " If you wanna keep going we can change the status line. We can change how
  " we invoke python
  call s:temp_buffer()

endfunction

" Pydoc Split Cword: {{{1
function! pydoc_help#SplitPydocCword() abort
  let s:temp_cword = expand('<cWORD>')
  split
  enew
  exec ':r! pydoc ' . s:temp_cword
  call s:temp_buffer()
endfunction

" Pydoc Arg: {{{1

function! pydoc_help#Pydoc(module) abort

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

  enew
  if has('python3')
    " I realize i could do that EOF bullshit but i don't like it.
    if has('unix')
      exec 'r! python3 -m pydoc ' . a:module
    else
      " exec 'r! python -m pydoc ' . a:module
      call s:get_documents(a:module)

    endif

  elseif has('python')  " not sure how to guarantee that python points to py2...
    exec 'r! python -m pydoc ' . a:module
  endif

  call s:temp_buffer()
endfunction

function! pydoc_help#doc() abort  " {{{1 use pydoc in a here-script

python3 << EOF

import inspect, vim, sys, os, pydoc
import importlib

def get_documents(obj):
    """Definitely the wrong method from pydoc but a start."""
    vim.current.window.buffer(pydoc.writedocs(obj))

EOF
" DON'T FORGET TO LEFT ALIGN THE EOF

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

function! pydoc_help#ShowPyDoc(name, type) abort  " {{{1
  " Args: name: lookup; type: 0: search, 1: lookup
    if a:name == ''
        return
    endif
    if bufloaded("__doc__")
        let l:buf_is_new = 0
        if bufname("%") == "__doc__"
            " The current buffer is __doc__, thus do not
            " recreate nor resize it
            let l:pydoc_wh = -1
        else
            " If the __doc__ buffer is open, jump to it
            if exists("g:pydoc_use_drop")
                execute "drop" "__doc__"
            else
                execute "sbuffer" bufnr("__doc__")
            endif
            let l:pydoc_wh = -1
        endif
    else
        let l:buf_is_new = 1
        execute g:pydoc_open_cmd '__doc__'
    endif

    setlocal modifiable
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal syntax=man
    setlocal nolist

    normal ggdG
    " Remove function/method arguments
    let s:name2 = substitute(a:name, '(.*', '', 'g' )
    " Remove all colons
    let s:name2 = substitute(s:name2, ':', '', 'g' )
    if a:type == 1
        let s:cmd = g:pydoc_cmd . ' ' . shellescape(s:name2)
    else
        let s:cmd = g:pydoc_cmd . ' -k ' . shellescape(s:name2)
    endif
    if &verbose
        echomsg "pydoc: calling " s:cmd
    endif
    execute  "silent read !" s:cmd
    normal 1G

    if exists('l:pydoc_wh') && l:pydoc_wh != -1
        execute "resize" l:pydoc_wh
    end

    if g:pydoc_highlight == 1
        execute 'syntax match pydoc' "'" . s:name2 . "'"
    endif

    let l:line = getline(2)
    if l:line =~ "^no Python documentation found for.*$"
        if l:buf_is_new
            execute "bdelete!"
        else
            normal u
            setlocal nomodified
            setlocal nomodifiable
        endif
        redraw
        echohl WarningMsg | echo l:line | echohl None
    else
        setlocal nomodified
        setlocal nomodifiable
    endif
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

function! pydoc_help#show_toc() abort  " {{{1
  let bufname = bufname('%')
  let info = getloclist(0, {'winid': 1})
  if !empty(info) && getwinvar(info.winid, 'qf_toc') ==# bufname
    lopen
    return
  endif

  let toc = []
  let lnum = 2
  let last_line = line('$') - 1
  let last_added = 0
  let has_section = 0
  let has_sub_section = 0

  while lnum && lnum <= last_line
    let level = 0
    let add_text = ''
    let text = getline(lnum)

    if text =~# '^=\+$' && lnum + 1 < last_line
      " A de-facto section heading.  Other headings are inferred.
      let has_section = 1
      let has_sub_section = 0
      let lnum = nextnonblank(lnum + 1)
      let text = getline(lnum)
      let add_text = text
      while add_text =~# '\*[^*]\+\*\s*$'
        let add_text = matchstr(add_text, '.*\ze\*[^*]\+\*\s*$')
      endwhile
    elseif text =~# '^[A-Z0-9][-A-ZA-Z0-9 .][-A-Z0-9 .():]*\%([ \t]\+\*.\+\*\)\?$'
      " Any line that's yelling is important.
      let has_sub_section = 1
      let level = has_section
      let add_text = matchstr(text, '.\{-}\ze\s*\%([ \t]\+\*.\+\*\)\?$')
    elseif text =~# '\~$'
          \ && matchstr(text, '^\s*\zs.\{-}\ze\s*\~$') !~# '\t\|\s\{2,}'
          \ && getline(lnum - 1) =~# '^\s*<\?$\|^\s*\*.*\*$'
          \ && getline(lnum + 1) =~# '^\s*>\?$\|^\s*\*.*\*$'
      " These lines could be headers or code examples.  We only want the
      " ones that have subsequent lines at the same indent or more.
      let l = nextnonblank(lnum + 1)
      if getline(l) =~# '\*[^*]\+\*$'
        " Ignore tag lines
        let l = nextnonblank(l + 1)
      endif

      if indent(lnum) <= indent(l)
        let level = has_section + has_sub_section
        let add_text = matchstr(text, '\S.*')
      endif
    endif

    let add_text = substitute(add_text, '\s\+$', '', 'g')
    if !empty(add_text) && last_added != lnum
      let last_added = lnum
      call add(toc, {'bufnr': bufnr('%'), 'lnum': lnum,
            \ 'text': repeat('  ', level) . add_text})
    endif
    let lnum = nextnonblank(lnum + 1)
  endwhile

  call setloclist(0, toc, ' ')
  call setloclist(0, [], 'a', {'title': 'Help TOC'})
  lopen
  let w:qf_toc = bufname

endfunction

" Atexit: {{{1
let &cpoptions = s:cpo_save
unlet s:cpo_save
