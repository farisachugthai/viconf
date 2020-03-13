" ============================================================================
  " File: mappings.vim
  " Author: Faris Chugthai
  " Description: Mappings
  " Last Modified: February 16, 2020
" ============================================================================

" Navigation: {{{
xnoremap < <gv
xnoremap > >gv

" I just realized these were set to nnoremap. Meaning visual mode doesn't get this mapping
noremap j gj
noremap k gk
noremap <Up> gk
noremap <Down> gj

" I mess this up constantly thinking that gI does what gi does
inoremap gI gi

" Literally ` does the same thing as ' but ` remembers column.
nnoremap ' `

" }}}

" Z Mappings: {{{
nnoremap zE <nop>
nnoremap zH zt
" Huh so zt is like z<CR> but we stay in the same column
nnoremap zt z<CR>
" I wanna make zM redraw with the cursor in the middle but thats already
" redraw with all folds closed. Also center is z. so thats easy enouh to
" remember i guess
" nnoremap zM
nnoremap zL z-
" }}}

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

" Misc: {{{

nnoremap <Leader>cd <Cmd>cd %:p:h<CR><Bar><Cmd>pwd<CR>
nnoremap Q gq
" xnoremap <BS> d
" doesn't work! but C-h is backspace soooo
xnoremap <C-h> d
nnoremap <Leader>sp <Cmd>setlocal spell!<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

nnoremap ,e :e **/*<C-z><S-Tab>

nnoremap ,f :find **/*<C-z><S-Tab>

" The nvim API is seriously fantastic.
nnoremap <Leader>rt call buffers#EchoRTP()
" }}}

" RSI: {{{
function! MapRsi() abort

  " Sorry tpope <3
  inoremap        <C-A> <C-O>^
  inoremap   <C-X><C-A> <C-A>
  cnoremap        <C-A> <Home>
  cnoremap   <C-X><C-A> <C-A>

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
endfunction

call MapRsi()
" }}}

function! AddVileBinding(key, handler)  " {{{
  " Map a key 3 times for normal mode, insert and command.
  exec 'nnoremap ' . a:key a:handler
  exec 'inoremap ' . a:key a:handler
  " I think tnoremap makes more sense here.
  exec 'tnoremap ' . a:key a:handler

endfunction " }}}

" Vile Bindings: {{{

" oh
call AddVileBinding('<C-x>o', '<Cmd>wincmd W<CR>')
" zero
call AddVileBinding('<C-x>0', '<Cmd>wincmd c<CR>')

call AddVileBinding('<C-x>1', '<Cmd>wincmd o<CR>')

" Both Tmux and Readline utilize C-a. It's a useful keybinding and
" my preferred manner of going to col-0 in insert mode. Cue vim-rsi
" a la Tim Pope. Cool. It'd be kinda cool to have that in normal mode.
nnoremap C-a ^
" But now I can't increment stuff.
" I just realized today {Oct 01, 2019} that the + key in normal mode does
" nothing different than <CR>. Wtf???
nnoremap + C-a

" As a nod to the inspiration I also want it in insert-mode
call AddVileBinding('<C-x><C-r>', '<Cmd>source $MYVIMRC<CR>echomsg "Reread $MYVIMRC"<CR>')

" info so possibly not cannonical
call AddVileBinding('<C-x>w', '<Cmd> set wrap!')

" Swap the mark and point
xnoremap <C-x><C-x> o
" }}}

" Brofiles: {{{ Note: you can add a complete with no nargs?
command! -bang -bar -complete=arglist Brofiles
      \ call fzf#run(fzf#wrap('oldfiles',
      \ {'source': v:oldfiles,
      \ 'sink': 'sp',
      \ 'options': g:fzf_options}, <bang>0))

call AddVileBinding('<C-x>b', '<Cmd>Brofiles<CR>')

" Make shift-insert work like in Xterm. From arch
call AddVileBinding('<S-Insert>', '<MiddleMouse>')
" }}}

" Search Mappings: {{{

" Toggle hlsearch with the same key that `less` does
nnoremap <M-u> <Cmd>set hlsearch!<CR>

" Dude read over :he getcharsearch(). Now ; and , search forward backward no matter what!!!
nnoremap <expr> ; getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'

" These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" If you highlight something in Visual mode, you should be able to use '#' and
" '*' to search for it.
xnoremap * y/<C-R>"<CR>
xnoremap # y?<C-R>"<CR>

" here's a great idea from justinmk:
" mark searches before you start
nnoremap / ms/
" let's extend justin's idea with ours!
" get rid of the gv it's super confusing
xnoremap / msy/<C-R>"<CR>

" }}}

" Make Shift Insert Work Like In Xterm: {{{
noremap <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>
tnoremap <S-Insert> <MiddleMouse>
" }}}

" Use The Down Arrow When The Pums Open: {{{
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>
inoremap <Up> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>Up>"<CR>

" }}}

" UltiSnips: {{{

noremap <F4> <Cmd>UltiSnipsEdit<CR>
noremap! <F4> <Cmd>UltiSnipsEdit<CR>

if exists(':Snippets')
  noremap <F6> <Cmd>Snippets<CR>
  noremap! <F6> <Cmd>Snippets<CR>
else
  noremap <F6> <Cmd>UltiSnipsListSnippets<CR>
  noremap! <F6> <Cmd>UltiSnipsListSnippets<CR>
endif

" Changed the mapping to Alt-= for snippets.
inoremap <silent> <M-=> <C-R>=(plugins#ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>
" }}}

" FZF: {{{

noremap <F6>                <Cmd>Snippets<CR>
noremap! <F6>               <Cmd>Snippets<CR>
" I suppose for continuity
tnoremap <F6>               <Cmd>Snippets<CR>

" Ensure fzf behaves similarly in a shell or in Vim: {{{
if exists('*fzf#wrap')
  nnoremap <M-x>                      <Cmd>Commands<CR>
  nnoremap <C-x><C-b>                 <Cmd>Buffers<CR>
  nnoremap <C-x><C-f>                 <Cmd>Files ~/<CR>
else
  nnoremap <M-x>                      <Cmd>verbose command<CR>
  nnoremap <C-x><C-b>                 <Cmd>buffers<CR>
  nnoremap <C-x><C-f>                 :<C-u>find ~/**
endif
" }}}

" Imaps: {{{
if has('unix')
  if executable('ag')
    imap <C-x><C-f> <Plug>(fzf-complete-file-ag)
    imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
  else
    imap <C-x><C-f> <Plug>(fzf-complete-file)
    imap <C-x><C-j> <Plug>(fzf-complete-path)
  endif
else
    imap <C-x><C-f>       <Plug>(fzf-complete-file)
    imap <C-x><C-j>       <Plug>(fzf-complete-path)
    inoremap <C-f>        <C-x><C-f>
    inoremap <C-j>        <C-x><C-j>
endif

inoremap <expr> <C-x><C-l> fzf#vim#complete#line()
inoremap <expr> <C-l>      fzf#vim#complete#line()

" Uhhh C-b for buffer?
inoremap <expr> <C-x><C-b> fzf#vim#complete#buffer_line()

imap <expr> <C-x><C-s>    fzf#vim#complete#word({
    \ 'source':  'cat /usr/share/dict/words',
    \ 'reducer': function('<sid>make_sentence'),
    \ 'options': '--multi --reverse --margin 15%,0',
    \ 'left':    40})
" And add a shorter version
inoremap <C-s>            <C-x><C-s>
imap <expr> <C-x><C-k>    fzf#complete({
            \ 'source': 'cat ~/.config/nvim/spell/en.utf-8.add $_ROOT/share/dict/words 2>/dev/null',
            \ 'options': '-ansi --multi --cycle', 'left': 30})
inoremap <C-k>            <C-x><C-k>

" }}}

" Backslash Tab: {{{
" NOTE: The imap should probably only be invoked using \<tab>
nmap \<tab>                 <Plug>(fzf-maps-n)
omap \<tab>                 <Plug>(fzf-maps-o)
xmap \<tab>                 <Plug>(fzf-maps-x)
imap \<tab>                 <Plug>(fzf-maps-i)

" }}}

" Map Vim Defaults To FZF History Commands:{{{
nnoremap q:        <Cmd>History:<CR>
nnoremap q/        <Cmd>History/<CR>
" But id still want to use q: when i can
nnoremap q; q:

" }}}

" Get The Rest Of The FZF Vim Commands Involved: {{{
nnoremap  <Leader>l         <Cmd>Lines<CR>
nnoremap  <Leader>s         <Cmd>Ag <C-R><C-W><CR>
nnoremap  <Leader>s         <Cmd>Ag <C-R><C-A><CR>
xnoremap  <Leader>s         y<Cmd>Ag <C-R>"<CR>
nnoremap  <Leader>`         <Cmd>Marks<CR>

" FZF beat fugitive out on this one. Might take git log too.
nnoremap <Leader>gg         <Cmd>GGrep<CR>
nnoremap <Leader>gl         <Cmd>Commits<CR>
nnoremap <Leader>g?         <Cmd>GFiles?<CR>

" NERDTree Mapping: Dude I forgot I had this. Make sure :Files works but this
" mapping is amazing.
nnoremap <expr> <Leader>n   (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

nnoremap ,b                 <Cmd>Buffers<CR>
nnoremap ,B                 <Cmd>Buffers<CR>

" }}}

" }}}

" Coc: {{{

" General Mappings: {{{
" TODO: Might need to open a pull request he states that these are mapped by
" default. omap af and omap if didn't show anything
onoremap af <Plug>(coc-funcobj-a)
onoremap if <Plug>(coc-funcobj-i)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" So I got rid of supertab and ultisnips is finally set in a consistent way
" with inoremaps and FZF and doesn't overlap with too much of the C-x C-f
" family and their abbreviations. JESUS that got tough.

" Let's give Coc the tab key. If this doesn't work as expected we can also go
" with something like <M-/>
inoremap <expr> <M-/> pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" : coc#refresh()


" Refresh completions with C-Space
" imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-p>")<cr>
inoremap <expr> <C-Space> coc#refresh()

" As a heads up theres also a coc#select#snippet
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap gK <Plug>(coc-definition)<CR>
" The gu<text object> operation is too important
" nnoremap <expr><buffer> gu <Plug>(coc-usages)<CR>
nnoremap g} <Plug>(coc-usages)<CR>
" }}}

" Bracket maps: {{{
" Shit none of these work
" oh also these are builtin mappings
" nnoremap [g <Plug>(coc-diagnostic-prev)<CR>
" nnoremap ]g <Plug>(coc-diagnostic-next)<CR>

" Note: Tried adding <expr> and didn't work
" nnoremap [c  <Plug>(coc-git-prevchunk)<CR>
" nnoremap ]c  <Plug>(coc-git-nextchunk)<CR>
" }}}

" Remap for rename current word: {{{
nnoremap <F2> <Plug>(coc-refactor)<CR>

" Instead of actually writing a '<,'> are we allowed to use the * char?
xnoremap <F2> <Cmd>'<,'>CocCommand document.renameCurrentWord<CR>
" }}}

" CocOpenLog: {{{2
" TODO: Why does this raise an error?
" nnoremap <expr> ,l coc#client#open_log()
nnoremap ,l <Cmd>CocOpenLog<CR>
" And let's add one in for CocInfo
nnoremap ,i <Cmd>CocInfo<CR>
" }}}

" Grep By Motion: Mnemonic CocSelect {{{2

" Don't use vmap I don't want this in select mode!
" Yo why dont we use onoremap though?
" Q: How to grep by motion?
" A: Create custom keymappings like:
xnoremap ,cs :<C-u>call plugins#GrepFromSelected(visualmode())<CR>
nnoremap ,cs :<C-u>set operatorfunc=plugins#GrepFromSelected<CR>g@

" Show all diagnostics
command! -nargs=0 CocDiagnostic call CocActionAsync('diagnosticInfo')
" }}}

" Maps For CocList X: {{{
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
" }}}

" CocResume: {{{
" Amazingly leader j k and p aren't taken. From the readme
nnoremap <Leader>j  :<C-u>CocNext<CR>
nnoremap ,j  :<C-u>CocNext<CR>
nnoremap <Leader>k  :<C-u>CocPrev<CR>
nnoremap ,k  :<C-u>CocPrev<CR>
nnoremap <Leader>r  :<C-u>CocListResume<CR>
nnoremap ,r  :<C-u>CocListResume<CR>
" }}}

" Other Mappings: {{{
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
nnoremap ,u <Plug>(coc-references)<CR>

nnoremap ,. <Plug>(coc-command-repeat)<CR>

" Autofix problem of current line
nnoremap ,f  <Plug>(coc-fix-current)<CR>
nnoremap ,q  <Plug>(coc-fix-current)<CR>
" }}}

" }}}

function! Window_Mappings() abort  " {{{
  " Navigate windows more easily
  nnoremap <C-h> <Cmd>wincmd h<CR>
  " This displays as <NL> when you run `:map` but it behaves like C-j. Oh well.
  nnoremap <C-j> <Cmd>wincmd j<CR>
  nnoremap <C-k> <Cmd>wincmd k<CR>
  nnoremap <C-l> <Cmd>wincmd l<CR>
  " Resize windows a little faster
  nnoremap <C-w>< 5<C-w><
  nnoremap <C-w>> 5<C-w>>
  nnoremap <C-w>+ 5<C-w>+
  nnoremap <C-w>- 5<C-w>-
  " Also don't make me hit the shift key
  nnoremap <C-w>, 5<C-w><
  nnoremap <C-w>. 5<C-w>>

  " Navigate Windows More Easily:
  nnoremap <Leader>ws <Cmd>wincmd s<CR>
  nnoremap <Leader>wv <Cmd>wincmd v<CR>
  nnoremap <Leader>ww <Cmd>wincmd w<CR>
  " Split and edit file under the cursor
  nnoremap <Leader>wf <Cmd>wincmd f<CR>
endfunction  " }}}

function! Quickfix_Mappings() abort  " {{{
  " Jump to and from location/quickfix windows.

  " TODO: These need to catch E776 no location list
  nnoremap <C-Down> <Cmd>llast<CR><bar><Cmd>clast<CR>
  nnoremap <C-Up> <Cmd>lfirst<CR><bar><Cmd>cfirst<CR>

  nnoremap <Leader>lc <Cmd>lclose<CR>
  nnoremap <Leader>lf <Cmd>lwindow<CR>

  " Normally the quickfix window is at the bottom of the screen.  If there are
  " vertical splits, it's at the bottom of the rightmost column of windows.  To
  " make it always occupy the full width:
  " use botright.
  nnoremap <Leader>lh <Cmd>botright lhistory<CR>
  nnoremap <Leader>ll <Cmd>botright llist!<CR>
  nnoremap <Leader>lo <Cmd>lopen<CR>
  nnoremap <Leader>lw <Cmd>botright lwindow<CR>

  " So this is contingent on having the qf plugin. need to add a check for
  " that later.
  " this is defined globally instead of only in the after/ftplugin/qf.vim
  " because it toggles the location list and so we want to have that mapping
  " defined everywhere.
  nnoremap <Leader>l <Plug>(qf_loc_toggle)
  nnoremap <Leader>ln <Plug>(qf_loc_next)
  nnoremap <Leader>lp <Plug>(qf_loc_previous)
  nnoremap <Leader>lo <Plug>(qf_loc_toggle)
  nnoremap <Leader>lc <Cmd>lclose<CR>
  nnoremap <Leader>lf <Cmd>lwindow<CR>

  " VSCode toggles maximized panel with this one so i guess lets match
  nnoremap <C-\\> <Plug>(qf_qf_toggle)
  nnoremap <Leader>q <Plug>(qf_qf_toggle)

  nnoremap <Leader>qp <Plug>(qf_older)
  nnoremap <Leader>qn <Plug>(qf_newer)
  nnoremap <Leader>qc <Cmd>cclose<CR>
  nnoremap <Leader>qf <Cmd>cwindow<CR>

  " Wanna note how long Ive been using Vim and still i onlyjust found out
  " about the chistory and lhistory commands like wth
  nnoremap <Leader>qh <Cmd>botright chistory<CR>
 nnoremap <Leader>ql <Cmd>botright clist!<CR>
  nnoremap <leader>qo <Cmd>botright copen<CR>
  nnoremap <Leader>qw <Cmd>botright cwindow<CR>

  nnoremap <Leader>C <Cmd>make %<CR>

endfunction  " }}}

function! AltKeyNavigation() abort  " {{{
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
endfunction  " }}}

function! Buffer_Mappings() abort  " {{{

  " Navigate Buffers More Easily:
  " Also note I wrote a Buffers command that utilizes fzf.
  nnoremap <Leader>bb <Cmd>Buffers<CR>
  nnoremap <Leader>bd <Cmd>bdelete<CR>
  " like quit
  nnoremap <Leader>bq <Cmd>bdelete!<CR>
  " like eXit
  nnoremap <Leader>bx <Cmd>bwipeout<CR>
  nnoremap <Leader>bu <Cmd>bunload<CR>
  nnoremap <Leader>bm <Cmd>bm<CR>
  nnoremap <Leader>bn <Cmd>bnext<CR>
  nnoremap <Leader>bp <Cmd>bprev<CR>
  nnoremap <Leader>b0 <Cmd>bfirst<CR>
  nnoremap <Leader>b$ <Cmd>blast<CR>
  " aka yank the whole buffer
  nnoremap <Leader>by <Cmd>"+%y<CR>
  " and then paste it
  nnoremap <Leader>bp <Cmd>"+gp<CR>
  " Sunovabitch bonly isn't a command?? Why is
  " noremap <Leader>bo <Cmd>bonly<CR>

  nnoremap <Leader>bs <Cmd>sbuffer<CR>
  nnoremap <Leader>bv <Cmd>vs<CR>
  nnoremap ]b <Cmd>bnext<CR>
  nnoremap [b <Cmd>bprev<CR>
  nnoremap ]B <Cmd>blast<CR>
  nnoremap [B <Cmd>bfirst<CR>
endfunction  " }}}

function! Tab_Mappings() abort  " {{{1

  nnoremap <Leader>tn <Cmd>tabnext<CR>
  nnoremap <Leader>tp <Cmd>tabprev<CR>
  nnoremap <Leader>tq <Cmd>tabclose<CR>
  nnoremap <Leader>tc <Cmd>tabclose<CR>
  nnoremap <Leader>T  <Cmd>tabs<CR>
  nnoremap <Leader>te <Cmd>tabedit<CR>
  " ngl pretty surprised that that cword didn't need an expand()
  nnoremap <Leader>t# <Cmd>tabedit <cword><CR>
  " Need to decide between many options
  " nnoremap <Leader>tg <Cmd>tabedit
  " poop can't do this
  " nnoremap <Leader>tn <Cmd>tabnew<CR>
  nnoremap <Leader>tf <Cmd>tabfirst<CR>
  nnoremap <Leader>tl <Cmd>tablast<CR>

  nnoremap ]t <Cmd>tabn<CR>
  nnoremap [t <Cmd>tabp<CR>
  nnoremap ]T <Cmd>tablast<CR>
  nnoremap [T <Cmd>tabfirst<CR>
endfunction
" }}}

" Call Functions: {{{
if !exists('no_plugin_maps') && !exists('no_windows_vim_maps')
  call Window_Mappings()
  call AltKeyNavigation()
  call Buffer_Mappings()
  call Tab_Mappings()
  call Quickfix_Mappings()
endif
" }}}

" Fugitive: {{{
function UserFugitiveMappings() abort
  nnoremap <Leader>gb   <Cmd>Gblame<CR>
  nnoremap <Leader>gc   <Cmd>Gcommit<CR>
  nnoremap <Leader>gd   <Cmd>Gdiffsplit!<CR>
  cabbrev Gd Gdiffsplit!<Space>
  nnoremap <Leader>gds  <Cmd>Gdiffsplit --staged<CR>
  cabbrev gds2 Git diff --stat --staged
  nnoremap <Leader>gds2 <Cmd>Git difftool --stat --staged<CR>
  nnoremap <Leader>ge   <Cmd>Gedit<Space>
  nnoremap <Leader>gf   <Cmd>Gfetch<CR>
  cabbrev gL 0Glog --pretty=oneline --graph --decorate --abbrev --all --branches
  nnoremap <Leader>gL   <Cmd>0Glog --pretty=format:lo --graph --decorate --abbrev --all --branches<CR>
  nnoremap <Leader>gm   <Cmd>Git mergetool<CR>
  " Make the mapping longer but clear as to whether gp would pull or push
  nnoremap <Leader>gp  <Cmd>Gpull<CR>
  nnoremap <Leader>gP  <Cmd>Gpush<CR>
  nnoremap <Leader>gq   <Cmd>Gwq<CR>
  nnoremap <Leader>gQ   <Cmd>Gwq!<CR>
  nnoremap <Leader>gR   <Cmd>Gread<Space>
  nnoremap <Leader>gs   <Cmd>Gstatus<CR>
  nnoremap <Leader>gst  <Cmd>Git diffsplit! --stat<CR>
  nnoremap <Leader>gw   <Cmd>Gwrite<CR>
  nnoremap <Leader>gW   <Cmd>Gwrite!<CR>
endfunction

call UserFugitiveMappings()
" }}}

" Tags: {{{
nnoremap ]g <Cmd>stjump!<CR>
xnoremap ]g <Cmd>stjump!<CR>

" Thank you index.txt!
" From: 2.2 Window commands                                             *CTRL-W*
" |CTRL-W_g_CTRL-]| CTRL-W g CTRL-]
" split window and do |:tjump| to tag under cursor
nnoremap <Leader>w] <C-w>g<C-]>
nnoremap ]w <C-w>g<C-]>

nnoremap <Leader>wc <Cmd>wincmd c<CR>
nnoremap <Leader>wo <Cmd>wincmd o<CR>

" No tabnext takes this one
" nnoremap ]t <Cmd>PreviewTag<CR>

" Mnemonic: goto like mosts other g commands and \ is the key we're left free
nnoremap <g-\> [I:let nr = input("Choose an include: ")<Bar>exe "normal! " . nr ."[\t"<CR>

" nnoremap <2-LeftMouse> :exe "ptselect! ". expand("<cword>")<CR>

" }}}

" Syntax Plug Mappings: {{{
nnoremap <Plug>(HL) <Cmd>call syncom#HL()<CR>
nnoremap <Plug>(HiC) <Cmd>HiC<CR>
nnoremap <Plug>(HiQF) <Cmd>HiQF<CR>
nnoremap <Plug>(SyntaxInfo) <Cmd>SyntaxInfo<CR>

if !hasmapto('<Plug>(HL)')
  nnoremap <Leader>h <Plug>(HL)
endif  " }}}

" Terminal: {{{
" No dude go to buffers#terminal
" }}}
