" ============================================================================
    " File: Fugitive.vim
    " Author: Faris Chugthai
    " Description: Fugitive ftplugin
    " Last Modified: Oct 12, 2019
" ============================================================================
"
" Admittedly this feels quite weird; however, fugitive creates the status
" buffer in it's own filetype and it doesn't have my usual mappings!
" Not only that but it's created in GIT_DIR/.git so it doesn't even count as a
" usual file in the git tree.

call plugins#FugitiveMappings()
