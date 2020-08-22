" ==================================================================
  " File: mappings.vim
  " Author: Faris Chugthai
  " Description: Mappings
  " Last Modified: February 16, 2020
" ==================================================================

" Navigation:
  " ugh this is gonna be a hell of a lot of manual entries
  " nnoremap <Leader>      <Cmd>WhichKey'<Space>'<CR>
  " nnoremap <LocalLeader> <Cmd>WhichKey','<CR>
  xnoremap < <gv
  xnoremap > >gv

  " I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
  noremap j gj
  noremap k gk
  noremap <Up> gk
  noremap <Down> gj

" Tags:
  " I've always really liked that M-/ mapping from readline
  nnoremap <M-?> <Cmd>stjump!<CR>
  xnoremap <M-?> y<Cmd>stjump!<CR>

  nnoremap <C-k><C-\> <Cmd>stselect!<CR>
  xnoremap <C-k><C-\> y<Cmd>stselect!<CR>

  " Thank you index.txt!
  " From: 2.2 Window commands                                             *CTRL-W*
  " |CTRL-W_g_CTRL-]| CTRL-W g CTRL-]
  " split window and do |:tjump| to tag under cursor
  nnoremap <C-k><C-]> <C-w>g<C-]>
  nnoremap ]w <C-w>g<C-]>

  nnoremap <Leader>wc <Cmd>wincmd c<CR>
  nnoremap <Leader>wo <Cmd>wincmd o<CR>

  " No tabnext takes this one
  " nnoremap ]t <Cmd>PreviewTag<CR>
  " nah i want the jumps
  " nnoremap <C-i> <C-w><C-i>

  " Mnemonic: goto like mosts other g commands and \ is the key we're left free
  nnoremap <C-k>g [I:let nr = input("Choose an include: ")<Bar>exe "normal! " . nr ."[\t"<CR>

" Z Mappings:
  nnoremap zE <nop>
  nnoremap zH zt
  " Huh so zt is like z<CR> but we stay in the same column
  nnoremap zt z<CR>
  " I wanna make zM redraw with the cursor in the middle but thats already
  " redraw with all folds closed. Also center is z. so thats easy enouh to
  " remember i guess
  " nnoremap zM
  nnoremap zL z-

" Misc:
  if executable('htop')
    " Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
    " even in vim8.0+. Also requires htop which more than likely rules out Win32.

    " Need to use enew in case your previous buffer setl nomodifiable
    nnoremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop
  endif

  nnoremap <Leader>cd <Cmd>cd %:p:h<CR><Bar><Cmd>pwd<CR>
  nnoremap Q gq
  " xnoremap <BS> d
  " doesn't work! but C-h is backspace soooo
  xnoremap <C-h> d
  nnoremap <Leader>sp <Cmd>setlocal spell!<CR>
  nnoremap <Leader>o o<Esc>
  nnoremap <Leader>O O<Esc>
  nnoremap <Leader>fe :e **/*<C-z><S-Tab>

  nnoremap <Leader>ff :Find **/*<C-z><S-Tab>

  " The nvim API is seriously fantastic.
  nnoremap <Leader>rt <Cmd>call buffers#EchoRTP()<CR>

  " Lets make the clipboard more useful
  noremap  <S-Insert> <MiddleMouse>
  noremap! <S-Insert> <MiddleMouse>
  tnoremap <S-Insert> <MiddleMouse>

  " if you need C-v for something just use C-q but i want to paste.
  cnoremap <C-S-v> <C-r>"
  cnoremap <C-v> <C-r>"

  inoremap <silent> <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>
  inoremap <silent> <Up> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>Up>"<CR>

  nnoremap <Leader>v <Cmd>Vista!!<CR>
  " Fun bugs in Vim. Why do cw and ce do the same thing when dw and de don't?
  nnoremap cw cw<DEL>

" Marks:
  nnoremap [1 <Cmd>signature#marker#Goto('prev', 1, v:count)<CR>
  nnoremap ]1 <Cmd>signature#marker#Goto('next', 1, v:count)<CR>
  nnoremap [2 <Cmd>signature#marker#Goto('prev', 2, v:count)<CR>
  nnoremap ]2 <Cmd>signature#marker#Goto('next', 2, v:count)<CR>
  nnoremap [3 <Cmd>signature#marker#Goto('prev', 3, v:count)<CR>
  nnoremap ]3 <Cmd>signature#marker#Goto('next', 3, v:count)<CR>
  nnoremap [4 <Cmd>signature#marker#Goto('prev', 4, v:count)<CR>
  nnoremap ]4 <Cmd>signature#marker#Goto('next', 4, v:count)<CR>

  " '^  `^
  " I mess this up constantly thinking that gI does what gi does
  " To the position where the cursor was the last time
  " when Insert mode was stopped.  This is used by the |gi| command.
  " Not set when the |:keepjumps| command modifier was used.
  inoremap gI gi

  " Literally ` does the same thing as ' but ` remembers column.
  nnoremap ' `

" RSI:
if !exists('*MapRsi')
  function MapRsi() abort
    " Sorry tpope <3
    inoremap        <C-A> <C-O>^
    inoremap        <C-X><C-A> <C-A>
    cnoremap        <C-A> <Home>
    cnoremap        <C-X><C-A> <C-A>

    inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
    cnoremap        <C-B> <Left>

    inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
    cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

    inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

    inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
    cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

    noremap!        <M-b> <S-Left>
    noremap!        <M-f> <S-Right>
    noremap!        <M-d> <C-O>dw
    cnoremap        <M-d> <S-Right><C-W>
    noremap!        <M-n> <Down>
    noremap!        <M-p> <Up>
    noremap!        <M-BS> <C-W>
    noremap!        <M-C-h> <C-W>

    " did you know alt-t is complete in emacs? let's steal this one from ultisnips
    noremap! <M-t> <C-R>=(plugins#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

    noremap! <C-x>2  <Cmd>new<CR>
    noremap! <C-x>5  <Cmd>vnew<CR>
    noremap! <C-x>0  <Cmd>wincmd c<CR>

    " TODO: C-] for search would be amazing
  endfunction
endif

if !exists('*AddVileBinding')
  function AddVileBinding(key, handler)
    " Map a key 3 times for normal mode, insert and command.
    exec 'nnoremap ' . a:key a:handler
    exec 'inoremap ' . a:key a:handler
    " I think tnoremap makes more sense here.
    exec 'tnoremap ' . a:key a:handler
    " wait why did i get rid of cnoremap
    exec 'cnoremap ' . a:key a:handler
  endfunction

  " oh
  call AddVileBinding('<C-x>o', '<Cmd>wincmd W<CR>')
  " zero
  call AddVileBinding('<C-x>0', '<Cmd>wincmd c<CR>')
  call AddVileBinding('<C-x>1', '<Cmd>wincmd o<CR>')

  nnoremap C-a ^
  nnoremap + C-a

  " As a nod to the inspiration I also want it in insert-mode
  call AddVileBinding('<C-x><C-r>', '<Cmd>source $MYVIMRC<CR>echomsg "Reread $MYVIMRC"<CR>')

  " This is an info binding not an emacs so possibly not cannonical
  call AddVileBinding('<C-x>w', '<Cmd> set wrap!')

  " Swap the mark and point
  xnoremap <C-x><C-x> o

  call AddVileBinding('<C-x>b', '<Cmd>Brofiles<CR>')

  " Make shift-insert work like in Xterm. From arch
  call AddVileBinding('<S-Insert>', '<MiddleMouse>')

  " So this binding can work in any mode so long as the previewwindow is open
  " noremap <M-C-v>

  function s:GoToLine() abort
    " Holy shit this works!
    let s:line = input('Enter line #: ')
    exec 'normal! ' . s:line . 'G'
  endfunction

  inoremap <M-g> <Cmd>call <SID>GoToLine()<CR>
endif

" Search Mappings:
  " Toggle hlsearch with the same key that `less` does
  nnoremap <M-u> <Cmd>set hlsearch!<CR>

  " Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
  nnoremap <expr> ; getcharsearch().forward ? ';' : ','
  nnoremap <expr> , getcharsearch().forward ? ',' : ';'

  " These will make it so that going to the next one in a
  " search will center on the line it's found in.
  " Also add a mark for housekeeping
  nnoremap n mJnzzzv
  nnoremap N mKNzzzv

  " If you highlight something in Visual mode, you should be able to use '#' and
  " '*' to search for it.
  xnoremap * mNy/<C-R>"<CR>
  xnoremap # mPy?<C-R>"<CR>

  " here's a great idea from justinmk:
  " mark searches before you start
  nnoremap / mS/
  " Oh also do the backwards one too please!
  nnoremap ? mB?
  xnoremap / mS/
  xnoremap ? mB?

" UltiSnips:
  noremap <F4> <Cmd>UltiSnipsEdit<CR>
  noremap! <F4> <Cmd>UltiSnipsEdit<CR>

  if exists(':Snippets')
    noremap  <F6>               <Cmd>Snippets<CR>
    noremap! <F6>               <Cmd>Snippets<CR>
    tnoremap <F6>               <Cmd>Snippets<CR>
  else
    noremap  <F6>               <Cmd>UltiSnipsListSnippets<CR>
    noremap! <F6>               <Cmd>UltiSnipsListSnippets<CR>
    tnoremap <F6>               <Cmd>UltiSnipsListSnippets<CR>
  endif
  " inoremap <expr> <Tab> UltiSnips#ExpandSnippetOrJump()

" NERDTree Mapping:
  nnoremap <expr> <Leader>N   (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
  nnoremap <Leader>nt <Cmd>NERDTreeToggleVCS<CR>zz
  nnoremap <Leader>nf <Cmd>NERDTreeFind<CR>

  " Switch NERDTree root to dir of currently focused window.
  " Make mapping match Spacemacs.
  if exists(':GuiTreeviewToggle')
    nnoremap <Leader>0 <Cmd>GuiTreeviewToggle<CR>
  else
    nnoremap <Leader>0 <Cmd>NERDTreeToggleVCS<CR>
  endif

" Coc:
if !exists('*CocMappings')
  function! s:check_back_space() abort
    let l:col = col('.') - 1
    let l:ret = system('col') || getline('.')[l:col - 1]  =~# '\s'
    return l:ret
  endfunction

  function CocMappings() abort
    " This executes before coc is loaded
    " if !exists('g:did_coc_loaded')
    "   echo 'Coc was never loaded'
    "   return
    " endif

  " General Mappings:
    onoremap af <Plug>(coc-funcobj-a)
    onoremap if <Plug>(coc-funcobj-i)

    " So I got rid of supertab and ultisnips is finally set in a consistent way
    " with inoremaps and FZF and doesn't overlap with too much of the C-x C-f
    " family and their abbreviations. JESUS that got tough.

    " Let's give Coc the tab key. If this doesn't work as expected we can also go
    " with something like <M-/>

    inoremap <expr> <M-=> pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ?
      \ "\<C-R>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \  <SID>check_back_space() ? "\<TAB>" : coc#refresh()

    " Refresh completions with C-Space
    inoremap <M-/> <C-R>=SuperTabAlternateCompletion("\<lt>c-p>")<CR>
    inoremap <expr> <C-Space> coc#refresh()

    nnoremap <C-k>d <Plug>(coc-definition)<CR>
    " The gu<text object> operation is too important
    nnoremap <expr><buffer> <Leader>u <Plug>(coc-usages)<CR>
    nnoremap ,u <Plug>(coc-usages)<CR>

    nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
    nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"

  " Bracket Maps:
    " Shit none of these work oh also these are builtin mappings
    nnoremap [g <Plug>(coc-diagnostic-prev)<CR>
    nnoremap ]g <Plug>(coc-diagnostic-next)<CR>

  " Git: Note: Tried adding <expr> and didn't work
    " nnoremap [c  <Plug>(coc-git-prevchunk)<CR>
    " nnoremap ]c  <Plug>(coc-git-nextchunk)<CR>

    nnoremap <F2> <Plug>(coc-refactor)<CR>

    " Instead of actually writing a '<,'> are we allowed to use the * char?
    xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>

    " TODO: Why does this raise an error?
    " nnoremap <expr> ,l coc#client#open_log()
    nnoremap ,l <Cmd>CocOpenLog<CR>
    " And let's add one in for CocInfo
    nnoremap ,i <Cmd>CocInfo<CR>

    inoremap <M-w> <C-R>=coc#start({'source': 'word'})<CR>

  " Grep By Motion: Mnemonic CocSelect
    " Don't use vmap I don't want this in select mode!
    " Yo why dont we use onoremap though?
    " Q: How to grep by motion?
    " A: Create custom keymappings like:
    xnoremap ag :<C-u>call plugins#GrepFromSelected(visualmode())<CR>
    nnoremap ag :<C-u>set operatorfunc=plugins#GrepFromSelected<CR>g@

  " Maps For CocList X:
    nnoremap <C-g> <Cmd>CocList<CR>
    nnoremap ,d  <Cmd>CocList diagnostics<CR>
    " nnoremap ,d <Plug>(coc-diagnostic-info)<CR>
    " Manage extensions
    nnoremap ,e  <Cmd>CocList extensions<CR>
    " Show commands
    nnoremap ,c  <Cmd>CocList commands<CR>
    " Find symbol of current document
    nnoremap ,o  <Cmd>CocList outline<CR>
    " Search workspace symbols
    nnoremap ,s  <Cmd>CocList -I symbols<CR>

  " Easier Grep Using CocList Words:
    nnoremap ,w <Cmd>execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'<CR>

    " Keymapping for grep word under cursor with interactive mode
    nnoremap ,g <Cmd>exe 'CocList -I --input=' . expand('<cword>') . ' grep'<CR>

  " CocResume:
    " Amazingly leader j k and p aren't taken. From the readme
    nnoremap <Leader>j  <Cmd>CocNext<CR>
    nnoremap ,j         <Cmd>CocNext<CR>
    nnoremap <Leader>k  <Cmd>CocPrev<CR>
    nnoremap ,k         <Cmd>CocPrev<CR>
    nnoremap <Leader>r  <Cmd>CocListResume<CR>
    nnoremap ,r         <Cmd>CocListResume<CR>

  " Other Mappings:
    xnoremap ,m  <Plug>(coc-format-selected)<CR>
    nnoremap ,m  <Plug>(coc-format-selected)<CR>

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xnoremap ,a  <Plug>(coc-codeaction-selected)<CR>
    " Remap for do codeAction of current line
    nnoremap ,a  <Plug>(coc-codeaction)<CR>

    " Now codeLens. No reason for h outside of it not being bound.
    nnoremap ,h <Plug>(coc-codelens-action)<CR>

    " Open the URL in the same way as netrw
    nnoremap gx <Plug>(coc-openlink)<CR>

    " Coc Usages
    nnoremap ,n <Plug>(coc-references)<CR>
    nnoremap ,. <Plug>(coc-command-repeat)<CR>

    " Autofix problem of current line
    nnoremap ,q  <Plug>(coc-fix-current)<CR>

    " doQuickFixes
    nnoremap ,p <Cmd>CocFixCurrent<CR>
    nnoremap ,z <Cmd>CocFloatHide<CR>
    nnoremap ,y <Cmd>CocFloatJump<CR>
  endfunction
endif

" ALE:
  " Follow the lead of vim-unimpaired with a for ale
  nnoremap ]a <Cmd>ALENextWrap<CR>zz
  nnoremap [a <Cmd>ALEPreviousWrap<CR>zz

  " `:ALEInfoToFile` will write the ALE runtime information to a given filename.
  " The filename works just like |:w|.

  " <Meta-a> now gives detailed messages about what the linters have sent to ALE
  nnoremap <A-a> <Cmd>ALEDetail<CR><bar>:normal! zz<CR>

  " I'm gonna make all my ALE mappings start with Alt so it's easier to distinguish
  nnoremap <A-r> <Cmd>ALEFindReference<CR>

  " Dude why can't i get plug mappings right???
  nnoremap <A-i> <Cmd>ALEInfo<CR>
  inoremap <C-.> <Plug>(ale_complete)

if !exists('*Window_Mappings')
  function Window_Mappings() abort
    " Navigate windows more easily
    " nnoremap <C-h> <Cmd>wincmd h<CR>
    " This displays as <NL> when you run `:map` but it behaves like C-j. Oh well.
    " nnoremap <C-j> <Cmd>wincmd j<CR>
    " nnoremap <C-k> <Cmd>wincmd k<CR>
    " nnoremap <C-l> <Cmd>wincmd l<CR>
    nnoremap <C-l> <Cmd>redraw!<CR><Cmd>redrawstatus!<CR><Cmd>redrawtabline<CR>

    " Resize windows a little faster
    nnoremap <C-w>< 5<C-w><
    nnoremap <C-w>> 5<C-w>>
    nnoremap <C-w>+ 5<C-w>+
    nnoremap <C-w>- 5<C-w>-
    " Also don't make me hit the shift key
    nnoremap <C-w>, 5<C-w><
    nnoremap <C-w>. 5<C-w>>

    " Navigate Windows More Easily:
    " Split and edit file under the cursor
    nnoremap <Leader>wf <Cmd>wincmd f<CR>
    nnoremap <Leader>wh <Cmd>topleft vnew<CR>
    nnoremap <leader>wj <Cmd>botright new<CR>
    nnoremap <leader>wk <Cmd>topleft new<CR>
    nnoremap <leader>wl <Cmd>botright vnew<CR>

    nnoremap <Leader>ws <Cmd>wincmd s<CR>
    nnoremap <Leader>wv <Cmd>wincmd v<CR>
    nnoremap <Leader>ww <Cmd>wincmd w<CR>
    nnoremap <Leader>w- <Cmd>wincmd s<CR>
    nnoremap <Leader>w\| <Cmd>wincmd v<CR>
    nnoremap <Leader>w2 <Cmd>wincmd v<CR>

    " Resizing Windows:
    " nnoremap <C-w><C-Left>
    nnoremap <C-w><C-Down> <C-w>-
    " nnoremap <C-w><C-Right>
    nnoremap <C-w><C-Up> <C-w>+
    " nnoremap <C-w><M-Left>
    nnoremap <C-w><M-Down> 5<C-w>-
    " nnoremap <C-w><M-Right>
    nnoremap <C-w><M-Up> 5<C-w>+

    " TODO: fix the plethora of these that are wrong
    let g:which_key_map['w'] = {
        \ 'name' : '+windows' ,
        \ 'w' : ['<C-W>w'     , 'other-window']          ,
        \ 'd' : ['<C-W>c'     , 'delete-window']         ,
        \ '-' : ['<C-W>s'     , 'split-window-below']    ,
        \ '|' : ['<C-W>v'     , 'split-window-right']    ,
        \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
        \ 'h' : ['<C-W>h'     , 'window-left']           ,
        \ 'j' : ['<C-W>j'     , 'window-below']          ,
        \ 'l' : ['<C-W>l'     , 'window-right']          ,
        \ 'k' : ['<C-W>k'     , 'window-up']             ,
        \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
        \ 'J' : ['resize +5'  , 'expand-window-below']   ,
        \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
        \ 'K' : ['resize -5'  , 'expand-window-up']      ,
        \ '=' : ['<C-W>='     , 'balance-window']        ,
        \ 's' : ['<C-W>s'     , 'split-window-below']    ,
        \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
        \ '?' : ['Windows'    , 'fzf-window']            ,
        \ }
  endfunction
endif

if !exists('*Quickfix_Mappings')
  function Quickfix_Mappings() abort
    nnoremap <Leader>l <Plug>(qf_loc_toggle)
    " Jump to and from location/quickfix windows.
    nnoremap <Leader>lc <Cmd>lclose<CR>
    " Down for down
    nnoremap <Leader>ld <Cmd>botright llist!<CR>

    nnoremap <Leader>lf <Cmd>lwindow<CR>
    " Normally the quickfix window is at the bottom of the screen.  If there are
    " vertical splits, it's at the bottom of the rightmost column of windows.  To
    " make it always occupy the full width:
    " use botright.
    nnoremap <Leader>lh <Cmd>botright lhistory<CR>
    nnoremap <Leader>ll <Cmd>llist!<CR>

    " So this is contingent on having the qf plugin. need to add a check for
    " that later.
    " this is defined globally instead of only in the after/ftplugin/qf.vim
    " because it toggles the location list and so we want to have that mapping
    " defined everywhere.
    nnoremap <Leader>ln <Plug>(qf_loc_next)
    " nnoremap <Leader>lo <Cmd>lopen<CR>
    nnoremap <Leader>lo <Plug>(qf_loc_toggle)
    nnoremap <Leader>lp <Plug>(qf_loc_previous)
    nnoremap <Leader>lw <Cmd>botright lwindow<CR>

    let g:which_key_map['l'] = {
        \ 'name' : '+location list' ,
        \ 'c' : ['lclose'     , 'lclose']          ,
        \ 'd' : ['botright llist!'     , 'botright llist!']          ,
        \ 'f' : ['lwindow'     , 'lwindow']          ,
        \ 'h' : ['lhistory'     , 'botright lhistory']          ,
        \ 'l' : ['llist!'     , 'llist!']          ,
        \ 'n' : ['qf_loc_next'     , 'qf_loc_next']          ,
        \ 'o' : ['qf_loc_toggle'     , 'qf_loc_toggle']          ,
        \ 'p' : ['qf_loc_previous'     , 'qf_loc_previous']          ,
        \ 'w' : ['lwindow'     , 'botright lwindow']          ,
        \ }

    " VSCode toggles maximized panel with this one so i guess lets match
    nnoremap <M-\> <Plug>(qf_qf_toggle)
    nnoremap <Leader>q <Plug>(qf_qf_toggle)

    nnoremap <Leader>qc <Cmd>cclose<CR>
    " D for down
    nnoremap <Leader>qd <Cmd>botright clist!<CR>
    nnoremap <Leader>qf <Cmd>cwindow<CR>
    " Wanna note how long Ive been using Vim and still i only just found out
    " about the chistory and lhistory commands like wth
    nnoremap <Leader>qh <Cmd>botright chistory<CR>
    nnoremap <Leader>ql <Cmd>clist!<CR>
    nnoremap <Leader>qn <Plug>(qf_newer)
    nnoremap <leader>qo <Cmd>botright copen<CR>
    nnoremap <Leader>qp <Plug>(qf_older)
    " This one is kinda annoying. cwindow frequently only closes the window but doesn't open it
    nnoremap <Leader>qw <Cmd>botright cwindow<CR>

    nnoremap <Leader>C <Cmd>make %<CR>

    let g:which_key_map['q'] = {
        \ 'name' : '+quickfix list' ,
        \ 'c' : ['cclose'              , 'cclose']            ,
        \ 'd' : ['botright clist!'     , 'botright clist!']   ,
        \ 'f' : ['lwindow'             , 'lwindow']           ,
        \ 'h' : ['chistory'            , 'botright chistory'] ,
        \ 'l' : ['clist!'              , 'clist!']            ,
        \ 'n' : ['qf_newer'            , 'qf_newer']          ,
        \ 'o' : ['qf_loc_toggle'       , 'qf_loc_toggle']     ,
        \ 'p' : ['qf_older'            , 'qf_older']          ,
        \ 'w' : ['cwindow'             , 'botright cwindow']  ,
        \ }

    " Unimpaired Mappings: {{{
    " Map quickfix list, buffers, windows and tabs to *[ and *]
    " Note: A bunch more in ./tag_miscellany.vim
    nnoremap ]q <Cmd>cnext<CR>
    nnoremap [q <Cmd>cprev<CR>
    nnoremap ]Q <Cmd>clast<CR>
    nnoremap [Q <Cmd>cfirst<CR>
    nnoremap ]l <Cmd>lnext<CR>
    nnoremap [l <Cmd>lprev<CR>
    nnoremap ]L <Cmd>llast<CR>
    nnoremap [L <Cmd>lfirst<CR>

    " Unrelated but cmdline
    " It's annoying you lose a whole command from a typo
    cnoremap <Esc> <nop>
    " However I still need the functionality
    cnoremap <C-g> <Esc>
    " Avoid accidental hits of <F1> while aiming for <Esc>
    noremap! <F1> <Esc>
    " }}}
  endfunction
endif

if !exists('*AltKeyNavigation')
  function AltKeyNavigation() abort
    " Not required but certainly useful
    nmap <M-w> <C-w>

    noremap  <M-h> <C-\><C-N><C-w>h
    noremap  <M-j> <C-\><C-N><C-w>j
    noremap  <M-k> <C-\><C-N><C-w>k
    noremap  <M-l> <C-\><C-N><C-w>l
    noremap! <M-h> <C-\><C-N><C-w>h
    noremap! <M-j> <C-\><C-N><C-w>j
    noremap! <M-k> <C-\><C-N><C-w>k
    noremap! <M-l> <C-\><C-N><C-w>l

    " Cant do this anymore. C-k is a prefix key now
    " and insert mode C-j does stuff, C-l is clear screen and C-h is BS
    " Originally this inspired primarily for terminal use but why not put it everywhere?
    noremap  <A-h> <C-w>h
    noremap  <A-j> <C-w>j
    noremap  <A-k> <C-w>k
    noremap  <A-l> <C-w>l
    noremap! <A-h> <C-w>h
    noremap! <A-j> <C-w>j
    noremap! <A-k> <C-w>k
    noremap! <A-l> <C-w>l
    " we might be in vim
    if !exists('*nvim_list_tabpages') | return | endif

    " First check we have more than 1 tab.
    if len(nvim_list_tabpages()) > 1
      noremap  <A-Right>  <Cmd>tabnext<CR>
      noremap  <A-Left>   <Cmd>tabprev<CR>
      noremap! <A-Right>  <Cmd>tabnext<CR>
      noremap! <A-Left>   <Cmd>tabprev<CR>
    elseif len(nvim_list_wins()) > 1
      noremap  <A-Right>  <Cmd>wincmd l<CR>
      noremap  <A-Left>   <Cmd>wincmd h<CR>
      noremap! <A-Right>  <Cmd>wincmd l<CR>
      noremap! <A-Left>   <Cmd>wincmd h<CR>
    endif
  endfunction
endif

function! Buffer_Mappings() abort
  " Navigate Buffers More Easily:
  " Also note I wrote a Buffers command that utilizes fzf.
  nnoremap <Leader>ba <Cmd>ball<CR>
  nnoremap <Leader>bb <Cmd>Buffers<CR>
  if exists(':Buffers') ==# 2  " It exists
    nnoremap <Leader>bb <Cmd>Buffers<CR>
  else
    nnoremap <Leader>bb <Cmd>buffers!<CR>
  endif
  nnoremap <Leader>bd <Cmd>bdelete<CR>
  nnoremap <Leader>bf <Cmd>bfirst<CR>
  " I just realized that i dont have \b hjkl
  nnoremap <Leader>bl <Cmd>blast<CR>
  nnoremap <Leader>bm <Cmd>bmodified<CR>
  nnoremap <Leader>bn <Cmd>bnext<CR>
  nnoremap <Leader>bp <Cmd>bprev<CR>
  " like quit
  nnoremap <Leader>bq <Cmd>bdelete!<CR>
  nnoremap <Leader>bs <Cmd>sbuffer<CR>
  nnoremap <Leader>bv <Cmd>vs<CR>
  nnoremap <Leader>bu <Cmd>bunload<CR>
  " like eXit
  nnoremap <Leader>bx <Cmd>bwipeout<CR>
  nnoremap <Leader>b0 <Cmd>bfirst<CR>
  nnoremap <Leader>b$ <Cmd>blast<CR>
  " aka yank the whole buffer
  nnoremap <Leader>by <Cmd>"+%y<CR>
  " and then paste it
  nnoremap <Leader>bP <Cmd>"+gp<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>

  nnoremap ]b <Cmd>bnext<CR>
  nnoremap [b <Cmd>bprev<CR>
  nnoremap ]B <Cmd>blast<CR>
  nnoremap [B <Cmd>bfirst<CR>

  " May 20, 2020: For all of these mappings, it's still annoying moving around
  " buffers. And <C-^> kinda helps but not enough
  nnoremap <M-1> 1<C-^>
  nnoremap <M-2> 2<C-^>
  nnoremap <M-3> 3<C-^>
  nnoremap <M-4> 4<C-^>
  nnoremap <M-5> 5<C-^>
  nnoremap <M-6> 6<C-^>
  nnoremap <M-7> 7<C-^>
  nnoremap <M-8> 8<C-^>
  nnoremap <M-9> 9<C-^>
  nnoremap <M-0> 10<C-^>

  " How have i never thought of this one!
  nnoremap <C-n> <Cmd>bn<CR>
  nnoremap <C-p> <Cmd>bp<CR>

  " Create new menus not based on existing mappings:
  let g:which_key_map.b = {
       \ 'name' : '+buffer' ,
       \ '1' : ['b1'        , 'buffer 1']        ,
       \ '2' : ['b2'        , 'buffer 2']        ,
       \ 'a' : ['ball'      , 'ball']            ,
       \ 'b' : ['Buffers'   , 'fzf-buffer']      ,
       \ 'd' : ['bd'        , 'delete-buffer']   ,
       \ 'f' : ['bfirst'    , 'first-buffer']    ,
       \ 'l' : ['blast'     , 'last-buffer']     ,
       \ 'm' : ['bmodified' , 'modified']     ,
       \ 'n' : ['bnext'     , 'next-buffer']     ,
       \ 'p' : ['bprevious' , 'previous-buffer'] ,
       \ 'q' : ['bdelete!'  , 'quit buffer'] ,
       \ 's' : ['sbuffer'   , 'sbuffer'] ,
       \ 'u' : ['bunload'   , 'bunload'] ,
       \ 'v' : ['vs'        , 'vs'] ,
       \ 'x' : ['bwipeout'  , 'bwipeout'] ,
       \ '?' : ['Buffers'   , 'fzf-buffer']      ,
       \ }
endfunction

if !exists('*Tab_Mappings')
  function Tab_Mappings() abort
    nnoremap <Leader>T  <Cmd>tabs<CR>
    nnoremap <Leader>tc <Cmd>tabclose<CR>
    nnoremap <Leader>te <Cmd>tabedit<CR>
    nnoremap <Leader>tf <Cmd>tabfirst<CR>
    nnoremap <Leader>tl <Cmd>tablast<CR>
    nnoremap <Leader>tn <Cmd>tabnext<CR>
    nnoremap <Leader>to <Cmd>tabonly<CR>
    nnoremap <Leader>tp <Cmd>tabprev<CR>
    nnoremap <Leader>tq <Cmd>tabclose<CR>
    " ngl pretty surprised that that cword didn't need an expand()
    nnoremap <Leader>t# <Cmd>tabedit <cword><CR>
    " Need to decide between many options
    " nnoremap <Leader>tg <Cmd>tabedit
    " poop can't do this
    " nnoremap <Leader>tn <Cmd>tabnew<CR>

      let g:which_key_map['t'] = {
          \ 'name' : '+tabs' ,
          \ 'c' : ['tabclose'            , 'tabclose']          ,
          \ 'e' : ['tabedit'             , 'tabedit']           ,
          \ 'f' : ['tabfirst'            , 'tabfirst']          ,
          \ 'l' : ['tablast'             , 'tablast']           ,
          \ 'n' : ['tabnext '            , 'tabnext']           ,
          \ 'o' : ['tabonly'             , 'tabonly']           ,
          \ 'p' : ['tabprev'             , 'tabprev']           ,
          \ 'q' : ['tabclose'            , 'tabclose']          ,
          \ '#' : ['tabedit <cword>'     , 'tabedit <cword>']   ,
          \ }

    nnoremap ]t <Cmd>tabn<CR>
    nnoremap [t <Cmd>tabp<CR>
    nnoremap ]T <Cmd>tablast<CR>
    nnoremap [T <Cmd>tabfirst<CR>
  endfunction
endif

function! UserFugitiveMappings() abort
  nnoremap <Leader>ga   <Cmd>Git add %<CR>
  nnoremap <Leader>gA   <Cmd>Git add .<CR>
  nnoremap <Leader>gb   <Cmd>Git blame<CR>
  " remember there are now a lot of other mappings that commit too
  nnoremap <Leader>gc   <Cmd>Git commit<CR>
  nnoremap <Leader>gcd   <Cmd>Gcd<Space>
  nnoremap <Leader>gcl   <Cmd>Gclog!<CR>
  nnoremap <Leader>gd   <Cmd>Gdiffsplit!<CR>
  cabbrev Gd Gdiffsplit!<Space>
  nnoremap <Leader>gds  <Cmd>Gdiffsplit --staged<CR>
  nnoremap <Leader>gdt   <Cmd>Git difftool<CR>
  cabbrev gds2 Git diff --stat --staged<Space>
  nnoremap <Leader>gds2 <Cmd>Git difftool --stat --staged<CR>
  nnoremap <Leader>ge   <Cmd>Gedit<Space>
  nnoremap <Leader>gf   <Cmd>Git fetch<CR>
  cabbrev gL 0Glog --pretty=oneline --graph --decorate --abbrev --all --branches
  nnoremap <Leader>gll   <Cmd>Gllog!<CR>
  nnoremap <Leader>gL   <Cmd>0Glog --pretty=format:lo --graph --decorate --abbrev --all --branches<CR>
  nnoremap <Leader>gm   <Cmd>Git mergetool<CR>
  " Make the mapping longer but clear as to whether gp would pull or push
  nnoremap <Leader>gp  <Cmd>Gpull --tags -r<CR>
  nnoremap <Leader>gP  <Cmd>Git push<CR>
  nnoremap <Leader>gq   <Cmd>Gwq<CR>
  nnoremap <Leader>gQ   <Cmd>Gwq!<CR>
  nnoremap <Leader>gR   <Cmd>Gread<Space>
  nnoremap <Leader>gs   <Cmd>Gstatus<CR>
  nnoremap <Leader>gst  <Cmd>Git diffsplit! --stat<CR>
  nnoremap <Leader>gw   <Cmd>Gwrite<CR>
  nnoremap <Leader>gW   <Cmd>Gwrite!<CR>

  let g:which_key_map.g = {
       \ 'name' : '+git' ,
       \ 'a' : ['Git add %'      , 'Git add %']            ,
       \ 'A' : ['Git add .'   , 'Git add .']      ,
       \ 'b' : ['Git blame'   , 'Git blame']      ,
       \ }
endfunction

function! Terminals() abort
  " If running a terminal in Vim, go into Normal mode with Esc
  tnoremap <Esc> <C-\><C-n>

  " From he term. Alt-R is better because this causes us to lose C-r in every
  " command we run from nvim
  tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'

  " From :he terminal
  tnoremap <M-h> <C-\><C-N><C-w>h
  tnoremap <M-j> <C-\><C-N><C-w>j
  tnoremap <M-k> <C-\><C-N><C-w>k
  tnoremap <M-l> <C-\><C-N><C-w>l

  " Move around the line
  tnoremap <M-A> <Esc>A
  tnoremap <M-b> <Esc>b
  tnoremap <M-d> <Esc>d
  tnoremap <M-f> <Esc>f

  " Other window
  tnoremap <C-w>w <C-\><C-N><C-w>w

  tnoremap <F4> <Cmd>Snippets<CR>
  tnoremap <F6> <Cmd>UltiSnipsEdit<CR>

  " It's so annoying that buffers need confirmation to kill. Let's dedicate a
  " key but one that we know windows hasn't stolen yet.
  tnoremap <D-z> <Cmd>bd!<CR>
endfunction

" Syntax Plug Mappings:
  nnoremap <Plug>(HL) <Cmd>call syncom#HL()<CR>
  nnoremap <Plug>(HiC) <Cmd>HiC<CR>
  nnoremap <Plug>(HiQF) <Cmd>HiQF<CR>
  nnoremap <Plug>(SyntaxInfo) <Cmd>SyntaxInfo<CR>

  if !hasmapto('<Plug>(HL)')
    nnoremap <Leader>H <Plug>(HL)
  endif

" Call Functions:
  if !exists('no_plugin_maps') && !exists('no_windows_vim_maps') && !exists('g:loaded_plugin_mappings')
    let g:which_key_map = {}
    call Window_Mappings()
    call AltKeyNavigation()
    call Buffer_Mappings()
    call Tab_Mappings()
    call Quickfix_Mappings()
    call MapRsi()
    " if exists('b:git_dir')  " before we reload this make sure were in a git dir
    " actually dont. we have to source it regardless and we may as well do it earlier
    " because &rtp is so long it takes longer for vim to figure than just telling it
    " endif
    call UserFugitiveMappings()
    call Terminals()
    call CocMappings()
    let g:loaded_plugin_mappings = 1
  endif
