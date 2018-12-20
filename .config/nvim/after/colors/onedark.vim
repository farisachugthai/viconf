" The original DiffText bg is unbearable.

" this needs to be before we call colorscheme so move this

" augroup colorextend
"     autocmd!
"     autocmd ColorScheme call onedark#extend_highlight('DiffText', {'bg': 'TODO'} )
" augroup end



" Original
"
" call s:h("DiffAdd", { "bg": s:green, "fg": s:black }) " diff mode: Added line
" call s:h("DiffChange", { "fg": s:yellow, "gui": "underline", "cterm": "underline" }) " diff mode: Changed line
" call s:h("DiffDelete", { "bg": s:red, "fg": s:black }) " diff mode: Deleted line
" call s:h("DiffText", { "bg": s:yellow, "fg": s:black }) " diff mode: Changed text within a changed line

" heres the full autoload function

" [onedark.vim](https://github.com/joshdick/onedark.vim/)

" let s:overrides = get(g:, "onedark_color_overrides", {})

" let s:colors = {
"       \ "red": get(s:overrides, "red", { "gui": "#E06C75", "cterm": "204", "cterm16": "1" }),
"       \ "dark_red": get(s:overrides, "dark_red", { "gui": "#BE5046", "cterm": "196", "cterm16": "9" }),
"       \ "green": get(s:overrides, "green", { "gui": "#98C379", "cterm": "114", "cterm16": "2" }),
"       \ "yellow": get(s:overrides, "yellow", { "gui": "#E5C07B", "cterm": "180", "cterm16": "3" }),
"       \ "dark_yellow": get(s:overrides, "dark_yellow", { "gui": "#D19A66", "cterm": "173", "cterm16": "11" }),
"       \ "blue": get(s:overrides, "blue", { "gui": "#61AFEF", "cterm": "39", "cterm16": "4" }),
"       \ "purple": get(s:overrides, "purple", { "gui": "#C678DD", "cterm": "170", "cterm16": "5" }),
"       \ "cyan": get(s:overrides, "cyan", { "gui": "#56B6C2", "cterm": "38", "cterm16": "6" }),
"       \ "white": get(s:overrides, "white", { "gui": "#ABB2BF", "cterm": "145", "cterm16": "7" }),
"       \ "black": get(s:overrides, "black", { "gui": "#282C34", "cterm": "235", "cterm16": "0" }),
"       \ "visual_black": get(s:overrides, "visual_black", { "gui": "NONE", "cterm": "NONE", "cterm16": "0" }),
"       \ "comment_grey": get(s:overrides, "comment_grey", { "gui": "#5C6370", "cterm": "59", "cterm16": "15" }),
"       \ "gutter_fg_grey": get(s:overrides, "gutter_fg_grey", { "gui": "#4B5263", "cterm": "238", "cterm16": "15" }),
"       \ "cursor_grey": get(s:overrides, "cursor_grey", { "gui": "#2C323C", "cterm": "236", "cterm16": "8" }),
"       \ "visual_grey": get(s:overrides, "visual_grey", { "gui": "#3E4452", "cterm": "237", "cterm16": "15" }),
"       \ "menu_grey": get(s:overrides, "menu_grey", { "gui": "#3E4452", "cterm": "237", "cterm16": "8" }),
"       \ "special_grey": get(s:overrides, "special_grey", { "gui": "#3B4048", "cterm": "238", "cterm16": "15" }),
"       \ "vertsplit": get(s:overrides, "vertsplit", { "gui": "#181A1F", "cterm": "59", "cterm16": "15" }),
"       \}

" function! onedark#GetColors()
"   return s:colors
" endfunction
"  ### Customizing onedark.vim's look without forking the repository
"  onedark.vim exposes `onedark#extend_highlight` and `onedark#set_highlight`
"  functions that you can call from within your `~/.vimrc` in order to
"  customize the look of onedark.vim. #### `onedark#extend_highlight`
"  `onedark#extend_highlight` allows you to customize individual aspects of
"  onedark.vim's existing highlight groups, overriding only the keys you
"  provide. (To completely redefine/override an existing highlight group, see
"  `onedark#set_highlight` below.) `onedark#extend_highlight`'s first
"  argunment should be the name of a highlight group, and its second argument
"  should be **partial** style data. Place the following lines **before** the
"  `colorscheme onedark` line in your `~/.vimrc`, then change the example
"  overrides to suit your needs: ```vim if (has("autocmd")) augroup
"  colorextend autocmd! " Make `Function`s bold in GUI mode autocmd
"  ColorScheme * call onedark#extend_highlight("Function", { "gui": "bold" })
"  " Override the `Statement` foreground color in 256-color mode autocmd
"  ColorScheme * call onedark#extend_highlight("Statement", { "fg": { "cterm":
"  128 } }) " Override the `Identifier` background color in GUI mode autocmd
"  ColorScheme * call onedark#extend_highlight("Identifier", { "bg": { "gui":
"  "#333333" } }) augroup END endif ``` #### `onedark#set_highlight`
"  `onedark#set_highlight` allows you to completely redefine/override
"  highlight groups of your choosing. `onedark#set_highlight`'s first argument
"  should be the name of a highlight group, and its second argument should be
"  **complete** style data. For example, to remove the background color only
"  when running in terminals (outside GUI mode and for use in transparent
"  terminals,) place the following lines **before** the `colorscheme onedark`
"  line in your `~/.vimrc`: ```vim " onedark.vim override: Don't set a
"  background color when running in a terminal; " just use the terminal's
"  background color " `gui` is the hex color code used in GUI mode/nvim
"  true-color mode " `cterm` is the color code used in 256-color mode "
"  `cterm16` is the color code used in 16-color mode if (has("autocmd") &&
"  !has("gui_running")) augroup colorset autocmd! let s:white = { "gui":
"  "#ABB2BF", "cterm": "145", "cterm16" : "7" } autocmd ColorScheme * call
"  onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be
"  styled since there is no `bg` setting augroup END endif ``` #### Global
"  color overrides You can override colors across all highlights by adding
"  color definitions to the `g:onedark_color_overrides` dictionary in your
"  `~/.vimrc` like so: ```vim let g:onedark_color_overrides = { \ "black":
"  {"gui": "#2F343F", "cterm": "235", "cterm16": "0" }, \ "purple": { "gui":
"  "#C678DF", "cterm": "170", "cterm16": "5" } \} ``` This also needs to be
"  done **before** `colorscheme onedark`. More examples of highlight group
"  names and style data can be found in onedark.vim's source code
"  (`colors/onedark.vim` inside this repository). ### tmux theme If you'd like
"  a tmux theme that complements onedark.vim, [@odedlaz has you
"  covered](https://github.com/odedlaz/tmux-onedark-theme).
