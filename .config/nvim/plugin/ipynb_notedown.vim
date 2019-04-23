" ipynb_notedown.vim:
" Plugin for editing Jupyter notebook (ipynb) files through notedown.
"
" Maintainer:   Michael Goerz <vimscripts@mail.michaelgoerz.net>
" URL:          https://michaelgoerz.net
" Script URL:   http://www.vim.org/scripts/script.php?script_id=5506
" Github:       https://github.com/goerz/ipynb_notedown.vim
" Last Change:  2016/12/26
" Version:      0.1.1
"
" Installation:
"    1. Copy the ipynb_notedown.vim script to your vim plugin directory (e.g.
"       $HOME/.vim/plugin).  Refer to ':help add-plugin', ':help
"       add-global-plugin' and ':help runtimepath' for more details about Vim
"       plugins.
"    2. Restart Vim.
"
" Usage:
"    When you open a Jupyter Notebook (*.ipynb) file, it is automatically
"    converted from json to markdown through the `notedown` utility
"    (https://github.com/aaren/notedown). Upon saving the file, the content is
"    converted back to the json notebook format.
"
"    The purpose of this plugin is to allow editing notebooks directly in vim.
"    The conversion json -> markdown -> json is relatively lossless, although
"    some of the restrictions of the `notedown` utility apply. In particular,
"    notebook and cell metadata are lost, and consecutive markdown cells are
"    merged into once cell
"
" Configuration:
"    The following settings in your ~/.vimrc may be used to configure the
"    plugin:
"
"    *  g:notedown_enable=1
"
"       You may disable the automatic conversion between the notebook json
"       format and markdown (i.e., deactivate this plugin) by setting this to
"       0.
"
"    *  g:notedown_code_match='all'

"       Value for the `--match` command line option of `notedown`.
"       There are known problems with using the value 'strict', but 'fenced'
"       may be a good alternative if you need code blocks in markdown.


" if plugin is already loaded then, not load plugin.
if exists("b:loaded_ipynb") || &cp || exists("#BufReadPre#*.ipynb")
    finish
endif
let b:loaded_ipynb = 1


" configuration
if !exists('g:notedown_enable')
    let g:notedown_enable = 1
endif
if !exists('g:notedown_code_match')
    let g:notedown_code_match = 'all'
endif


" set autocmd
augroup ipynb
    " Remove all ipynb autocommands
    au!

    autocmd BufReadPre,FileReadPre      *.ipynb    setlocal bin
    autocmd BufReadPost,FileReadPost    *.ipynb    call s:ipynb#read_ipynb_json()
    autocmd BufWritePost,FileWritePost  *.ipynb    call s:ipynb#write_ipynb_json()

augroup END


" vim: set sw=4 :

