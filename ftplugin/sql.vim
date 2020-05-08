" ============================================================================
  " File: sql.vim
  " Author: Faris Chugthai
  " Description: SQL ftplugin
  " Last Modified: January 04, 2020
" ============================================================================

" Globals: {{{

let g:ftplugin_sql_omni_key       = '<C-x>'
let g:ftplugin_sql_omni_key_right = '<M-n>'
let g:ftplugin_sql_omni_key_left  = '<M-p>'

" By default only look for CREATE statements, but allow
" the user to override
" if !exists('g:ftplugin_sql_statements')
let g:ftplugin_sql_statements = 'create'
" endif
" Predefined SQL objects what are used by the below mappings using
" the ]} style maps.
" This global variable allows the users to override its value
" from within their vimrc.
" Note, you cannot use \?, since these patterns can be used to search
" backwards, you must use \{,1}
if !exists('g:ftplugin_sql_objects')
    let g:ftplugin_sql_objects = 'function,procedure,event,' .
                \ '\(existing\\|global\s\+temporary\s\+\)\{,1}' .
                \ 'table,trigger' .
                \ ',schema,service,publication,database,datatype,domain' .
                \ ',index,subscription,synchronization,view,variable'
endif
" }}}

" SQL Specific: {{{
" That is a smart fucking way of doing this!
" TODO: change the guards in this dir to the below:

" Only do this when not done yet for this buffer
" This ftplugin can be used with other ftplugins.  So ensure loading
" happens if all elements of this plugin have not yet loaded.
if exists("b:did_ftplugin") && exists("b:current_ftplugin") && b:current_ftplugin == 'sql'
    finish
endif

setlocal omnifunc=sqlcomplete#Complete

source $VIMRUNTIME/ftplugin/sql.vim
" Also  source this directly otherwise you end up with a whole lot of `:runtime!` calls from
" the general $VIMRUNTIME/indent/sql.vim
source $VIMRUNTIME/indent/sqlanywhere.vim

" Comments can be of the form:
"   /*
"    *
"    */
" or
"   --
" or
"   //
setlocal comments=s1:/*,mb:*,ex:*/,:--,://
" }}}

