" ============================================================================
  " File: sql.vim
  " Author: Faris Chugthai
  " Description: SQL ftplugin
  " Last Modified: January 04, 2020
" ============================================================================

" Globals:
  let g:ftplugin_sql_omni_key       = '<M-c>'
  let g:ftplugin_sql_omni_key_right = '<A-n>'
  let g:ftplugin_sql_omni_key_left  = '<A-p>'

  " By default only look for CREATE statements, but allow
  " the user to override
  " if !exists('g:ftplugin_sql_statements')
  let g:ftplugin_sql_statements = 'create'
  " endif

" SQL Specific:
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

  if exists('b:did_ftplugin') | finish | endif


  " Dude holy fuck is this an ftplugin or what
  source $VIMRUNTIME/ftplugin/sql.vim

  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                        \. '|unlet! b:undo_ftplugin'
                        \. '|unlet! b:did_ftplugin'
