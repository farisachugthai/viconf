" ============================================================================
  " File: commands.vim
  " Author: Faris Chugthai
  " Description: All user created commands
  " Last Modified: February 16, 2020
" ============================================================================

" Tags Command: {{{
" You never added complete tags dude!
command! -complete=tag -bar Tagstack echo gettagstack(expand('%'))
command! -complete=tag -bar Tagfiles echo tagfiles()

command! -complete=tag -bar -bang FZTags call fzf#run(fzf#wrap('tags', {'source': 'gettagstack(expand("%"))', 'sink': 'e', 'options': g:fzf_options}, <bang>0))

" Open a tag for the word under the cursor in the preview window.
command! -complete=tag PreviewTag call buffers#PreviewWord()

command! EchoRTP echo buffers#EchoRTP()

" From `:he quickfix`
command! -complete=dir -bang -nargs=* NewGrep execute 'silent grep! <q-args>' | copen<bang>

" An example that uses the argument list and avoids errors for files without matches:
command! -complete=var -nargs=* -range SearchAll silent argdo try | grepadd! <args> %  | catch /E480:/ | endtry

command! TB setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m | clist
" }}}

" Coc Commands: {{{

command! CocWords execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'

command! CocRepeat call CocAction('repeatCommand')

command! CocReferences call CocAction('jumpReferences')

" TODO: Figure out the ternary operator, change nargs to ? and if arg then
" input=arg else expand(cword)
command! CocGrep execute 'CocList -I --input=' . expand('<cword>') . ' grep'

" Dec 05, 2019: Got a new one for ya!
command! CocExtensionStats :py3 from pprint import pprint; pprint(vim.eval('CocAction("extensionStats")'))

" Let's group these together by prefixing with Coc
" Use `:Format` to format current buffer
command! CocFormat call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? CocFold :setlocal fdm=manual | call CocActionAsync('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! CocSort call CocAction('runCommand', 'editor.action.organizeImport')

" Just tried this and it worked! So keep checking :CocList commands and add
" more as we go.
command! CocPython call CocActionAsync('runCommand', 'python.startREPL')

" Let's also get some information here.
" call CocAction('commands') is a lamer version of CocCommand
" similar deal with CocFix and CocAction() -quickfix
" actually ive overriding his coc fix  giving it the quickfix arg fucks
" something up

command! -nargs=* -range CocFix call coc#rpc#notify('codeActionRange', [<line1>, <line2>, <q-args>])

" Nabbed these from his plugin/coc.vim file and changed the mappings to
" commands
command! CocDefinition call CocAction('jumpDefinition')
command! CocDeclaration    call       CocAction('jumpDeclaration')
command! CocImplementation call       CocAction('jumpImplementation')
command! CocTypeDefinition call       CocAction('jumpTypeDefinition')
command! CocReferences     call       CocAction('jumpReferences')
command! CocOpenlink      call       CocActionAsync('openLink')
command! CocFixCurrent    call       CocActionAsync('doQuickfix')
command! CocFloatHide     call       coc#util#float_hide()
command! CocFloatJump     call       coc#util#float_jump()
command! -bar CocCommandRepeat call       CocAction('repeatCommand')
" How am I still going?
command! CocServices echo CocAction('services')

function! s:CocProviders(A, L, P) abort

  let s:list = ['rename', 'onTypeEdit', 'documentLink', 'documentColor', 'foldingRange',
        \ 'format', 'codeAction', 'workspaceSymbols', 'formatRange', 'hover',
	\ 'signature', 'documentSymbol', 'documentHighlight', 'definition',
        \ 'declaration', 'typeDefinition', 'reference', 'implementation', 'codeLens',
        \ 'selectionRange'
        \ ]
  return join(s:list, "\n")
endfunction

function! s:HandleCocProviders(provider) abort

  let s:resp = CocHasProvider(a:provider)
  if s:resp is v:true
    echomsg 'That provider *DOES* exist for your current document.'
  elseif s:resp is v:false
    echomsg 'That provider *DOES NOT* exist for your current document.'
  endif
  return s:resp

endfunction

" This gets way more complicated if you try to handle more than 1 arg
" command! -nargs=* -complete=custom,s:CocProviders CocProviders for i in [(<q-args>)] | call s:HandleCocProviders(i) | endfor

command! -nargs=1 -complete=custom,s:CocProviders CocProviders call s:HandleCocProviders(<args>)

" }}}

" A LOT Of FZF Commands: {{{

" Apr 23, 2019: Didn't know complete help was a thing.
" Oh holy shit that's awesome
" Ah fzf is too good jesus christ. He provided all the arguments for you so
" all you have to do is ask "bang or not?"
" Unfortunately the ternary expression <bang> ? 1 : 0 doesn't work; however,
" junegunn's <bang>0 does!
command! -bar -bang -nargs=* -complete=help Help call fzf#vim#helptags(<bang>0)

" scriptnames:
command! -bang -bar FZScriptnames call vimscript#fzf_scriptnames(<bang>0)

" fzf_for_todos
command! -bang -bar -complete=var -nargs=* TodoFuzzy call find_files#RipgrepFzf('todo ' . <q-args>, <bang>0)

" FZGrep:
  " here's the call signature for fzf#vim#grep
  " - fzf#vim#grep(command, with_column, [options], [fullscreen])
  "   If you're interested it would be kinda neat to modify that `dir` line

command! -complete=file_in_path -nargs=? -bang -bar FZGrep call fzf#run(fzf#wrap('grep', {
      \ 'source': 'silent! grep! <q-args>',
      \ 'sink': 'edit',
      \ 'options': ['--multi', '--ansi', '--border'],})
      \  fzf#vim#with_preview('up:60%')

	" -addr=buffers		Range for buffers (also not loaded buffers)

  " Gtfo it worked
command! -bang -bar -complete=file  -range -addr=buffers -nargs=* FZGGrep
  \   call fzf#vim#grep(
  \   'git grep --line-number --color=always ' . shellescape(<q-args>),
  \   0,
  \   {'dir': systemlist('git rev-parse --show-toplevel')[0]},
  \   <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'))

" Ag FZF With A Preview Window: {{{

"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -complete=dir -bang -bar -addr=buffers -nargs=* FZPreviewAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Rg: Use `:Rg` or `:FZRg` or `:FufRg` before this one
command! -bar -complete=dir -bang -nargs=* FZMehRg
  \ call fzf#run(fzf#wrap('rg', {
        \   'source': 'rg --no-column --no-line-number --no-heading --color=ansi'
        \   . ' --smart-case --follow ' . shellescape(<q-args>),
        \   'sink': 'vsplit',
        \   'options': ['--ansi', '--multi', '--border', '--cycle', '--prompt', 'FZRG:',]
        \ }, <bang>0))

" }}}

" Files With Preview Window: {{{

command! -bang -nargs=? -complete=dir -bar FZPreviewFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" }}}

" Plugins: {{{

function! s:Plugins(...) abort
  return sort(keys(g:plugs))
endfunction

" TODO: Sink doesnt work
command! -nargs=* -bang -bar -complete=customlist,s:Plugins FZPlugins
      \ call fzf#run(fzf#wrap(
      \ 'help',
      \ {'source': sort(keys(g:plugs)),
      \ 'sink'  : function('find_files#plug_help_sink'),
      \ 'options': g:fzf_options},
      \ <bang>0))
" }}}

command! -bar -bang -nargs=0 -complete=color FZColors
  \ call fzf#vim#colors({'left': '35%',
  \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" FZBuf: {{{ Works better than FZBuffers
command! -bar -bang -complete=buffer FZBuf call fzf#run(fzf#wrap('buffers',
    \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)')},
    \ <bang>0))
" }}}

" FZBuffers: Use Of g:fzf_options: {{{
  " As of Oct 15, 2019: this works. Also correctly locates files which none of my rg commands seem to do
command! -bang -complete=buffer -bar FZBuffers call fzf#run(fzf#wrap('buffers',
        \ {'source':  reverse(find_files#buflist()),
        \ 'sink':    function('find_files#bufopen'),
        \ 'options': g:fzf_options,
        \ 'down':    len(find_files#buflist()) + 2
        \ }, <bang>0))
" }}}

" FZMru:
" I feel like this could work with complete=history right?
command! -bang -bar FZMru call find_files#FZFMru()

" FZGit:
  " Oct 15, 2019: Works!
  " TODO: The above command should use the fzf funcs
  " and also use this
  " \   {'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
command! -bar -complete=file FZGit call find_files#FZFGit()

" Rg That Updates:
command! -bar -complete=dir -nargs=* -bang FZRg call find_files#RipgrepFzf(<q-args>, <bang>0)

" Doesn't update but i thought i was cool
command! -bar -complete=dir -bang -nargs=* FzRgPrev
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case ' . <q-args>,
  \   1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bar -bang -complete=dir -nargs=* FZLS
    \ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))

" only search projects lmao
command! -bar -bang FZProjectFiles call fzf#vim#files('~/projects', <bang>0)

" Or, if you want to override the command with different fzf options, just pass
" a custom spec to the function.
command! -bar -bang -nargs=? -complete=dir FZReverse
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)

" Want a preview window?
command! -bar -bang -nargs=? -complete=dir FZFilePreview
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)

command! -bar -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'source': 'fd -H -t f',
    \ 'options': [
    \ '--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}'
    \ ]}, <bang>0)

" Override his command to add completion
command! -bar -bang -nargs=? -complete=file GFiles call fzf#vim#gitfiles(<q-args>, <bang>0)

" Me just copy pasting his plugin
command! -bar -bang -complete=mapping IMaps call fzf#vim#maps("i", <bang>0)
command! -bar -bang -complete=mapping CMaps call fzf#vim#maps("c", <bang>0)
command! -bar -bang -complete=mapping TMaps call fzf#vim#maps("t", <bang>0)

" Add completion to his Maps command but define ours the same way
command! -bar -bang -nargs=? -complete=mapping Maps call fzf#vim#maps("n", <bang>0)

" }}}

" Finding Files: {{{

" Completes filenames from the directories specified in the 'path' option:
" doesnt work lol
command! -nargs=* -range=% -bang -bar -complete=customlist,unix#EditFileComplete -complete=file
        \ EdPreview :<q-mods> <line1>,<line2> pedit<bang> <q-args>

command! -nargs=* -bang -complete=file -complete=file_in_path Goto pedit<bang> <args>
" I admit feeling peer pressured to add this but
" -range=N    A count (default N) which is specified in the line
"             number position (like |:split|); allows for zero line
"             number.
command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete
        \ Split <q-mods>split<bang> <q-args>

" See if we cant catch me constantly mistyping :sb as :bs
command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete -range=0
        \ Bsplit <q-mods>split<bang> <q-args>

" Why not do the same for :Bd
command! -nargs=* -range=% -addr=buffers -count -bang -bar -complete=buffer Bdelete :<count><mods>bd<bang> <args>

command! -nargs=* -range=% -addr=buffers -count -bang -bar -complete=file_in_path Find :<count><mods>find<bang> <args>

" Well this is nice to know about. You can specify what a range refers to.
" -addr=loaded_buffers
command! -nargs=* -bang -bar -complete=buffer -range=% -addr=buffers
      \ BuffEdit <q-mods>buffer<bang> <q-args>

command! -nargs=* -bang -bar -complete=buffer -range=% -addr=buffers
      \ BuffsEdit <q-mods>buffers<bang> <q-args>

" }}}

" Miscellaneous: {{{

command!  -bang -complete=compiler -nargs=* Make
      \ if <args>
      \ for f in expand(<q-args>, 0, 1) |
      \ exe '<mods> make<bang>' . f |
      \ endfor
      \ else
      \ exe '<mods> make<bang>' . expand('%')

command! -bang -complete=compiler -nargs=* -range=% -addr=buffers MakeBuffers
      \ if <args>
      \ for f in expand(<q-args>, 0, 1) |
      \ exe '<mods> make<bang>' . f |
      \ endfor
      \ else
      \ exe '<mods> make<bang>' . expand('%')

command! -bar -nargs=1 -complete=history RerunLastX call histget(<args>, 1)

" TODO: make bang handle either open in split or full window
command! -bar Todo call todo#Todo()

" :he map line 1454. How have i never noticed this isn't a feature???
command! -nargs=? -bang -complete=buffer Rename file <q-args>|w<bang>za

" These 2 commands are for parsing the output of scriptnames though a command
" like :TBrowseScriptnames would probably be easier to work with:
command! -nargs=? -bar SNames call vimscript#Scriptnames(<f-args>)
command! -nargs=0 -bar SNamesDict echo vimscript#ScriptnamesDict()

" Useful if you wanna see all available funcs provided by nvim
command! -bang -nargs=0 NvimAPI
      \ new<bang> | put =map(filter(api_info().functions,
      \ '!has_key(v:val,''deprecated_since'')'),
      \ 'v:val.name')

" Easier mkdir and cross platform!
command! -complete=dir -nargs=1 Mkdir call mkdir(<q-args>, 'p', '0700')

" From `:he change`  line 352 tag g?g?
" Adding range means that the command defaults to current line
" Need to add a check that we're in visual mode and drop the '<,'> if not.
command! -nargs=0 -bar -range TitleCase execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

" }}}

" Pydoc: {{{

command! -bar -complete=expression -complete=function -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
" FUCK YEA! Dec 27, 2019: Behaves as expected!
" You know whats nice? Both of these expressions work.
" :Pd(vim.vars)
" :Pd vim.vars
command! -range -bar -complete=expression -complete=function -nargs=? Pd <line1>,<line2>python3 from pprint import pprint; pprint(dir(<args>))

command! -range -bar -complete=expression -complete=function -nargs=? P <line1>,<line2>python3 print(<args>)

command! -bar -range -nargs=+ Pi <line1>,<line2>python3 import <args>

command! -bang -bar PydocThis call pydoc_help#PydocCword(<bang>0, expand(<cword>))

" This should be able to take the argument '-bang' and allow to open in a new
" separate window like fzf does.
" NOTE: See :he func-range to see how range can get passed automatically to
" functions without being specified in the command definition
command! -nargs=? -bar PydocSplit call pydoc_help#SplitPydocCword(<q-mods>)

" command! -bar -bang -range PydocSp
"       \ exec '<mods>split<bang>:python3 import pydoc'.expand('<cWORD>').'; pydoc.help('.expand('<cWORD>').')'
" holy fuck i just beefed this command up a lot. now takes a bang and should
" work more correctly.
" todo: i think i added a completefunc thatll work perfectly
" Man i really messed this one up. Look through the git log to see the older
" invocations
" command! -nargs=? -bang Pydoc :<mods>file<bang> exec 'call pydoc_help#Pydoc(<f-args>)'

" todo: adding a bang expression didny work
command! -bang -complete=expression -bar PydocShow call pydoc_help#show(<bang>0)

" TODO: Work on the range then the bang
command! -complete=file -range BlackCurrent <line1>,<line2>call py#Black()

command! -nargs=* -complete=file -complete=file_in_path BlackThese call py#black_these(<f-args>)

function! s:IPythonOptions(...) abort
  let list = ['profile', 'history', 'kernel', 'locate']
  " Quote this with single quotes and it wont work correctly...WHAT THE FUCK
  return join(list, "\n")
endfunction

" So far works
command! -bar -bang -nargs=* -complete=dir -complete=custom,s:IPythonOptions IPy :<mods>term<bang> ipython <args>

command! -bar -bang -complete=buffer ScratchBuffer call pydoc_help#scratch_listed_buffer(<bang>0)

command! NvimCxn call py#Cxn()
" }}}

" Terminal Command: {{{
if !has('unix')
  setglobal sessionoptions+=unix,slash viewoptions+=unix,slash

  " So this HAS to be a bad idea; however, all 3 DirChanged autocommands emit
  " errors and that's a little insane
  " Oct 22, 2019: Somehow I've observed literally 0 problems with this and the
  " error is still emitted when the dir changes soooo
  setglobal eventignore=DirChanged

  command! SetCmd call msdos#set_shell_cmd()
  command! -nargs=? CmdInvoke call msdos#invoke_cmd(<f-args>)
  command! -nargs=? -complete=shellcmd Cmd call msdos#CmdTerm(<f-args>)
  command! PowerShell call msdos#PowerShell()

  command! -nargs=? PwshHelp call msdos#pwsh_help(shellescape(<f-args>))
else
  if executable('htop')
    " Leader -- applications -- htop. Requires nvim for <Cmd> which tmk doesn't exist
    " even in vim8.0+. Also requires htop which more than likely rules out Win32.

    " Need to use enew in case your previous buffer setl nomodifiable
    nnoremap <Leader>ah <Cmd>wincmd v<CR><bar><Cmd>enew<CR><bar>term://htop
  endif
endif
" }}}
"
" Chmod: {{{

" :S    Escape special characters for use with a shell command (see
"  |shellescape()|). Must be the last one. Examples:

" :!dir <cfile>:S
" :call system('chmod +w -- ' . expand('%:S'))

" From :he filename-modifiers in the cmdline page.

" More From The Bottom Of Help Map:
command! -bang -bar -nargs=+ -complete=file -complete=file_in_path EditFiles
    \ for f in expand(<q-args>, 0, 1) |
    \ exe '<mods> split ' . f<bang> |
    \ endfor

command!  -complete=file_in_path  -bang -bar -nargs=* -complete=file -complete=dir EditAny <mods>edit<bang> <q-args>

command! -nargs=+ -complete=file Sedit call unix#SpecialEdit(<q-args>, <q-mods>)

" There are more comfortable ways of doing the following in Vim.
" I'm not going to convince you it's better. That it's cleaner.
" Unfortunately, there are  few of *their* keybindings wired in.
" May as well map them correctly.
" }}}

" UltiSnips: {{{

command! -complete=filetype -bar UltiSnipsListSnippets call UltiSnips#ListSnippets()

" todo:
" command! -bar UltiSnipsListSnippetsAgain? call py#list_snippets()
" }}}

" In Which I Learn How Commands Work: {{{

" echos either 1 or 0
command! -bang Bang0 echo <bang>0
" echos nothing or '!' which is fucking pointless. Well unless you're giving
" it to an ex command. bang0 is definitely preferable for functions.
command! -bang Bang echo <bang>

" Learn Complete: Note that you haven't to provide nargs or typing a letter
" with stop the completion
command! -bar -bang -complete=compiler -nargs=1 Compiler compiler<bang> <args>
" '<,'>s/compiler/event/g
" You may find that ---^ does you good
command! -bar -complete=event Event event<args>

command! -bar -bang -complete=var -nargs=+ Var set<bang> <args>

" well check out how cool this is. shouldnt be so surprised that this works
command! -complete=environment -bar -nargs=+ Env let $<args>

command! -bar Redo call histget('cmd', -1)  " }}}

" Commands from the help pages. map.txt: {{{
" Replace a range with the contents of a file
" (Enter this all as one line)
command! -bar -range -nargs=1 -complete=file Replace <line1>-pu_|<line1>,<line2>d|r <args>|<line1>d

" Count the number of lines in the range. Wait how does this not need to
" concatenate the int and the str?
" DON'T PUT COMMENTS IN THE SAME LINE AS COMMANDS DINGUS
command! -bar -range -nargs=* Lines echomsg <line2> - <line1> + 1 'lines'
" }}}

" Platform Specific Settings: {{{
" dude omfg. exists($ANDROID_DATA) returns 0 on android.
" so does getenv($ANDROID_DATA) *specifically returns v:null*
" on windows i had a few expr return 1. like fuck you im trying to
" distinguish what computer im on this isnt the hard part
if !empty($ANDROID_DATA)
  " May 26, 2019: Just ran into my first problem from a filename with a space in the name *sigh*
  " admonition: dont use -bar here because we need to use bar as well
  " jeez this was frustrating... had to futz with where to add whitespace
  " and <CR> seeing as how  that fundammentally changes the command.
  command! -bang TermuxSend :silent! keepalt w<bang> <bar>exec '!termux-share -a send ' . expand('%:S')
  nnoremap <Leader>ts <Cmd>TermuxSend<CR>

endif  " }}}

" Fugitive Functions: {{{
function ProjectGitDir() abort
  " Like how would this not be really useful all the time?
  return FugitiveExtractGitDir(fnamemodify(expand('%'), ':p:h'))
endfunction

function ProjectRoot() abort
  return fnamemodify(fnameescape(ProjectGitDir()), ':p:h')
endfunction

command! -range -addr=arguments -bang -bar -nargs=* Gclone exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>) 
" }}}

" Syntax Highlighting: {{{

command! HL call syncom#HL()
command! HiC call syncom#HiC()
command! HiQF call syncom#HiQF()
command! SyntaxInfo call syncom#get_syn_info()

" Works:
command! HiTest call syncom#hitest()

" }}}
