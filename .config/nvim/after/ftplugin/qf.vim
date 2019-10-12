
if !get(g:, 'qf_disable_statusline')
  let b:undo_ftplugin = "set stl<"

  " Display the command that produced the list in the quickfix window:
  setlocal stl=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
endif

if !has(g:loaded_qf)
  finish
endif

let g:qf_mapping_ack_style = 1
