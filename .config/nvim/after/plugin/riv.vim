
" Riv: {{{2

" Highlight py docstrings with rst highlighting
let g:riv_python_rst_hl = 1
let g:riv_file_link_style = 2  " Add support for :doc:`something` directive.
let g:riv_ignored_maps = '<Tab>'
let g:riv_ignored_nmaps = '<Tab>'
let g:riv_i_tab_pum_next = 0

let g:riv_global_leader='<Space>'

" From he riv-instructions. **THIS IS THE ONE!!** UltiSnips finally works again
let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
let g:riv_fuzzy_help = 1
