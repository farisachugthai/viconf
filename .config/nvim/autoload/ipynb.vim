" ============================================================================
    " File: ipynb.vim
    " Author: Faris Chugthai
    " Description: IPynb Autoload
    " Last Modified: April 23, 2019
" ============================================================================
if exists('b:did_ipynb_vim') || &compatible || v:version < 700
    finish
endif
let b:did_ipynb_vim = 1

" Function to check that 'notedown' is available
" The result is cached in s:have_notedown for speed.
function! s:ipynb#check_notedown()
    if !exists('s:have_notedown')
        let e = executable('notedown')
        if e < 0
            let r = system('notedown')
            let e = (r !~? 'not found' && r !=? '')
        endif
        exe 'let s:have_notedown=' . e
    endif
    exe 'return s:have_notedown'
endfun

" after reading ipynb file, convert to markdown
function! s:ipynb#read_ipynb_json()
    if !g:notedown_enable
        return
    endif
    if !s:ipynb#check_notedown()
        echoerr('notedown not available. Install with `pip install notedown`')
        return
    endif
    " make 'patchmode' empty, we don't want a copy of the written file
    let pm_save = &pm
    set pm=
    " remove 'a' and 'A' from 'cpo' to avoid the alternate file changes
    let cpo_save = &cpo
    set cpo-=a cpo-=A
    ' set 'modifiable'
    let ma_save = &ma
    setlocal ma

    " when filtering the whole buffer, it will become empty
    let empty = line(''[') == 1 && line('']') == line('$')

    let tmp = tempname()
    let tmpe = tmp . '.' . expand('<afile>:e')

    " write the just read lines to a temp file
    execute 'silent '[,']w ' . tmpe

    " convert tmpe to text file
    let r =  system('notedown \'' . tmpe .
    \               '\' --from notebook --to markdown > \'' . tmp . '\'')
    if (r != '')
        echom r
        return
    endif

    " delete the compressed lines; remember the line number
    let l = line(''[') - 1
    if exists(':lockmarks')
        lockmarks '[,']d _
    else
        '[,']d _
    endif

    " read in the uncompressed lines ''[-1r tmp'
    setlocal bin
    if exists(':lockmarks')
        execute 'silent lockmarks ' . l . 'r ' . tmp
    else
        execute 'silent ' . l . 'r ' . tmp
    endif

    " if buffer became empty, delete trailing blank line
    if empty
        silent $delete _
        1
    endif
    " delete the temp file and the used buffers
    call delete(tmp)
    call delete(tmpe)
    silent! exe 'bwipe ' . tmp
    silent! exe 'bwipe ' . tmpe
    let &pm = pm_save
    let &cpo = cpo_save
    let &l:ma = ma_save
    " When uncompressed the whole buffer, do autocommands
    if empty
        if &verbose >= 8
            execute 'doau BufReadPost ' . expand('%:r')
        else
            execute 'silent! doau BufReadPost ' . expand('%:r')
        endif
    endif
endfun

" after writing file, convert back to ipynb json.
fun s:ipynb#write_ipynb_json()
    if (!g:notedown_enable)
        return
    endif
    if !s:check_notedown()
        echoerr("notedown not available")
        return
    endif
    let nm = expand("<afile>")
    let nmt = tempname()
    if rename(nm, nmt) == 0
        let r = system("notedown --from markdown --to notebook --match=" .
        \              g:notedown_code_match . " \""  . nmt . "\" > \"". nm
        \              . "\"")
        if (r != "")
            echom r
        endif
        call rename(nmt . "." . expand("<afile>:e"), nm)
    endif
endfun

