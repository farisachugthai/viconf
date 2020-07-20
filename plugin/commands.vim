" ============================================================================
  " File: commands.vim
  " Author: Faris Chugthai
  " Description: All user created commands
  " Last Modified: February 16, 2020
" ============================================================================

let s:repo_root = fnameescape(fnamemodify(resolve(expand('<sfile>')), ':p:h:h'))

" Tags Command:
  " You never added complete tags dude!
  command! -complete=tag -bar Tagstack echo gettagstack(expand('%'))
  command! -complete=tag -bar Tagfiles echo tagfiles()

  command! -complete=tag -bar -bang FZTags call fzf#run(fzf#wrap('tags', {'source': 'gettagstack(expand("%"))', 'sink': 'e', 'options': g:fzf_options}, <bang>0))

  command! EchoRTP echo buffers#EchoRTP()

  " From `:he quickfix`
  command! -complete=dir -bang -nargs=* NewGrep execute 'silent grep! <q-args>' | copen<bang>

  " An example that uses the argument list and avoids errors for files without matches:
  command! -complete=var -nargs=* -range SearchAll silent argdo try | grepadd! <args> %  | catch /E480:/ | endtry

  command! TB setl efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m | clist

" Coc Commands:
  " FOUND WHERE IT IS IN HIS SOURCE!
  " ~/.local/share/nvim/plugged/coc.nvim/src/plugin.ts : cocAction
  " public async cocAction(...args: any[]): Promise<any> {
  " Like 200 lines of rpc calls. so that'll give you some solid inspiration

  command! -bar CocQuickFixes echo CocAction('quickfixes')
  command! -bar -complete=custom,coc#list#options -nargs=* CocWords execute 'CocList -I --normal --input=' . expand('<cword>') . ' words'
  command! -bang -bar CocRepeat call CocAction('repeatCommand')
  command! -bang -bar CocReferences call CocAction('jumpReferences')

  command! -bar -nargs=* -bang -complete=custom,coc#list#options CocGrep execute 'CocList -I --input=' len(<q-args>) == 0 ? expand('<cword>') : '' . ' grep'

  " Dec 05, 2019: Got a new one for ya! Range doesnt do anything but py3 accepts it so
  command! -bang -bar -range CocExtensionStats <line1>,<line2>py3 from pprint import pprint; pprint(vim.eval('CocAction("extensionStats")'))

  " Let's group these together by prefixing with Coc
  " Use `:Format` to format current buffer
  command! -bar -bang -nargs=* CocFormat call CocActionAsync('format', <f-args>)

  " Show all diagnostics
  command! -bar -bang -nargs=* CocDiagnostic call CocActionAsync('diagnosticInfo', <f-args>)

  " Use `:Fold` to fold current buffer
  command! -bang -nargs=? CocFold setlocal fdm=manual | call CocActionAsync('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -bang -bar CocSort call CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Just tried this and it worked! So keep checking :CocList commands and add more as we go.
  " BUG: Running :topleft call CocActionAsync('runCommand', 'python.startREPL')
  " does not place the buffer at the top
  "
  " Does changing the command to `exec '<q-mods> ' . `  fix it?
  " command! -bang -bar CocPython call CocActionAsync('runCommand', 'python.startREPL')
  " Often enough that command doesn't work
  command! -bar -nargs=* -complete=dir -range -count -bang CocPython :exec "<q-mods> call coc#terminal#start('python', <q-args>, '')"

  " Let's also get some information here.
  " call CocAction('commands') is a lamer version of CocCommand
  " similar deal with CocFix and CocAction() -quickfix
  " actually ive overriding his coc fix  giving it the quickfix arg fucks
  " something up

  command! -bar -addr=lines -count -nargs=* -range CocFix call coc#rpc#notify('codeActionRange', [<line1>, <line2>, <q-args>])

  " Nabbed these from his plugin/coc.vim file and changed the mappings to
  " commands
  command! -bar CocDefinition     call       CocActionAsync('jumpDefinition')
  command! -bar CocDeclaration    call       CocActionAsync('jumpDeclaration')
  command! -bar CocImplementation call       CocActionAsync('jumpImplementation')
  command! -bar CocTypeDefinition call       CocActionAsync('jumpTypeDefinition')
  command! -bar CocReferences     call       CocActionAsync('jumpReferences')
  command! -bar CocOpenlink       call       CocActionAsync('openLink')
  command! -bar CocFixCurrent     call       CocActionAsync('doQuickfix')
  command! -bar CocFloatHide      call       coc#util#float_hide()
  command! -bar CocFloatJump      call       coc#util#float_jump()
  command! -bar CocCommandRepeat  call       CocActionAsync('repeatCommand')
  " How am I still going?
  "
  " Yo I found teh function that provides completion for coclist!!
  command! -bar -nargs=* -complete=custom,coc#list#options CocServices call coc#rpc#notify('openList', [<f-args>])

  function! s:CocProviders(A, L, P) abort

    let s:list = ['rename', 'onTypeEdit', 'documentLink', 'documentColor', 'foldingRange',
          \ 'format', 'codeAction', 'workspaceSymbols', 'formatRange', 'hover',
          \ 'signature', 'documentSymbol', 'documentHighlight', 'definition',
          \ 'declaration', 'typeDefinition', 'reference', 'implementation', 'codeLens',
          \ 'selectionRange'
          \ ]
    return join(s:list, "\n")
  endfunction

  function! s:HandleCocProviders(...) abort

    if len(a:000) is 0
      return
    endif
    let s:resp = CocHasProvider(a:1)
    if s:resp is v:true
      echomsg 'That provider *DOES* exist for your current document.'
    elseif s:resp is v:false
      echomsg 'That provider *DOES NOT* exist for your current document.'
    endif
    return s:resp

  endfunction

  " This gets way more complicated if you try to handle more than 1 arg
  " command! -nargs=* -complete=custom,s:CocProviders CocProviders for i in [(<q-args>)] | call s:HandleCocProviders(i) | endfor

  command! -bar -nargs=* -complete=custom,s:CocProviders CocProviders call s:HandleCocProviders(<q-args>)

" A LOT Of FZF Commands:
  " Brofiles:

    function! s:CompleteBrofiles(A, L, P)
      return v:oldfiles
    endfunction

    let s:fzf_options = get(g:, 'fzf_options', [])

    command! -bang -bar -nargs=* -complete=customlist,s:CompleteBrofiles Brofiles
          \ call fzf#run(fzf#wrap('oldfiles',
          \ {'source': v:oldfiles,
          \ 'sink': 'sp',
          \ 'options': s:fzf_options}, <bang>0))

    command! -bar -bang -nargs=* -complete=help Help call fzf#vim#helptags(<bang>0)
    command! -bang -bar FZScriptnames call vimscript#fzf_scriptnames(<bang>0)

    " fzf_for_todos
    command! -bang -bar -complete=var -nargs=* TodoFuzzy call find_files#RipgrepFzf('todo ' . <q-args>, <bang>0)

    " here's the call signature for fzf#vim#grep
    " - fzf#vim#grep(command, with_column, [options], [fullscreen])
    "   If you're interested it would be kinda neat to modify that `dir` line
    command! -complete=file_in_path -nargs=? -bang -bar FZGrep call fzf#run(fzf#wrap('grep', {
          \ 'source': 'silent! grep! <q-args>',
          \ 'sink': 'edit',
          \ 'options': ['--multi', '--ansi', '--border'],},
          \ <bang>0 ? fzf#vim#with_preview('up:60%') : 0))

    command! -bang -bar -complete=file -nargs=* GGrep
      \   call fzf#vim#grep(
      \   'git grep --line-number --color=always ' . shellescape(<q-args>),
      \   1,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

    "   :Ag! - Start fzf in fullscreen and display the preview window above
    command! -complete=dir -bang -bar -nargs=* FZPreviewAg
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

    command! -bang -nargs=? -complete=dir -bar FZPreviewFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    function! s:Plugins(...) abort
      return sort(keys(g:plugs))
    endfunction

    " TODO: Sink doesnt work
    command! -nargs=* -bang -bar -complete=customlist,s:Plugins FZPlugins
          \ call fzf#run(fzf#wrap(
          \ 'help',
          \ {'source': sort(keys(g:plugs)),
          \ 'sink'  : function('find_files#plug_help_sink'),
          \ 'options': s:fzf_options},
          \ <bang>0))

    " FZBuf: {{{ Works better than FZBuffers
    command! -bar -bang -complete=buffer FZBuf call fzf#run(fzf#wrap('buffers',
        \ {'source': map(range(1, bufnr('$')), 'bufname(v:val)'),
        \ 'sink': 'e',
        \ 'options': s:fzf_options,
        \ },
        \ <bang>0))

  " FZBuffers: Use Of g:fzf_options:
    " As of Oct 15, 2019: this works. Also correctly locates files which none of my rg commands seem to do
    command! -bang -complete=buffer -bar FZBuffers call fzf#run(fzf#wrap('buffers',
            \ {'source':  reverse(find_files#buflist()),
            \ 'sink':    function('find_files#bufopen'),
            \ 'options': s:fzf_options,
            \ 'down':    len(find_files#buflist()) + 2
            \ }, <bang>0))

    " FZMru:
    " I feel like this could work with complete=history right?
    command! -bang -bar -nargs=* -complete=customlist,s:CompleteBrofiles Mru call find_files#FZFMru(<bang>0)

    " FZGit:
      " Oct 15, 2019: Works!
      " TODO: The above command should use the fzf funcs
      " and also use this
    command! -bar -complete=file -bang GLsFiles call find_files#FZFGit(<bang>0)

    " Rg That Updates:
    command! -bar -complete=dir -nargs=* -bang FZRg call find_files#RipgrepFzf(<q-args>, <bang>0)

    " Doesn't update but i thought i was cool
    command! -bar -complete=dir -bang -nargs=* FzRgPrev
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case ' . <q-args>,
      \   1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'))

    command! -bar -bang -complete=dir -nargs=* LS
        \ call fzf#run(fzf#wrap(
        \ 'ls',
        \ {'source': 'ls', 'dir': <q-args>},
        \ <bang>0))

    command! -bar -bang Projects call fzf#vim#files('~/projects', <bang>0)

    " Or, if you want to override the command with different fzf options, just pass
    " a custom spec to the function.
    command! -bar -bang -nargs=* -complete=file RFiles
        \ call fzf#vim#files(<q-args>,
        \ {'options': [
            \ '--layout=reverse', '--info=inline'
        \ ]},
        \ <bang>0)

    " Want a preview window?
    command! -bar -bang -nargs=* -complete=file Preview
        \ call fzf#vim#files(<q-args>,
        \ { 'source': 'fd -H -t f',
        \ 'sink': 'botright split',
        \ 'options': [
        \     '--layout=reverse', '--info=inline',
        \     '--preview', 'bat --color=always {}'
        \ ]},
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'))

    command! -bar -bang -nargs=* -complete=file Files
        \ call fzf#vim#files(<q-args>,
        \ {'source': 'fd -H -t f',
        \ 'sink': 'pedit',
        \ 'options': [
        \     '--layout=reverse', '--info=inline', '--preview', expand('~/.vim/plugged/fzf.vim/bin/preview.sh') . '{}'
        \ ]},
        \ <bang>0)

  " Override His Commands To Add Completion:
    function! s:p(bang, ...)
      let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
      if len(preview_window)
        return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
      endif
      return {}
    endfunction

    " Add fugitives completion to make this command way better
    " FUCK YES THIS WORKS PERFECTLY HOLY FUCK
    command! -bar -bang -nargs=? -complete=customlist,fugitive#PathComplete GFiles call fzf#vim#gitfiles(<q-args>, <q-args> == "?" ? {} : s:p(<bang>0), <bang>0)
    command! -bar -bang -nargs=? -complete=customlist,fugitive#PathComplete GitFiles call fzf#vim#gitfiles(<q-args>, <q-args> == "?" ? {} : s:p(<bang>0), <bang>0)

    " Me just copy pasting his plugin with added completion
    command! -bar -bang -complete=mapping IMaps call fzf#vim#maps("i", <bang>0)
    command! -bar -bang -complete=mapping CMaps call fzf#vim#maps("c", <bang>0)
    command! -bar -bang -complete=mapping TMaps call fzf#vim#maps("t", <bang>0)

    " Add completion to his Maps command but define ours the same way
    command! -bar -bang -nargs=? -complete=mapping NMaps call fzf#vim#maps("n", <bang>0)
    command! -bar -bang -nargs=? -complete=mapping XMaps call fzf#vim#maps("x", <bang>0)
    command! -bar -bang -nargs=? -complete=mapping OMaps call fzf#vim#maps("o", <bang>0)

    command! -bar -bang -nargs=* -complete=color Colo
      \ call fzf#vim#colors({'left': '35%',
      \ 'options': '--reverse --margin 30%,0'}, <bang>0)

" Finding Files:
  " Completes filenames from the directories specified in the 'path' option:
  command! -nargs=* -bang -bar -complete=customlist,unix#EditFileComplete -complete=file -range=% -addr=buffers
          \ Pedit :pedit<bang> <q-args>

  command! -nargs=* -bang -complete=file -complete=file_in_path Hide :hide <q-mods> edit<bang> <args>

  command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete -range=% -addr=buffers
          \ Split <q-mods>split<bang> <q-args>

  " See if we cant catch me constantly mistyping :sb as :bs
  command! -nargs=* -bang -bar -complete=file -complete=customlist,unix#EditFileComplete -range=0
          \ Bsplit <q-mods>split<bang> <q-args>

  " Why not do the same for :Bd
  command! -nargs=* -count -bang -bar -complete=buffer -range=% -addr=buffers
        \ Bdelete v:count:bd<bang><args>

  command! -nargs=* -range=% -addr=buffers -count -bang -bar -complete=file_in_path Find :<count><mods>find<bang> <args>

  command! -nargs=* -bang -bar -complete=buffer -range=% -addr=buffers
        \ BEdit <q-mods>buffer<bang> <q-args>

" Miscellaneous:
" Fuck this doesnt work
  command! -bang -complete=compiler -nargs=* -range=% -addr=buffers MakeBuffers
        \| if <args> !=# ''
        \| for f in expand(<q-args>, 0, 1)
        \| exe '<mods> make<bang>' . f
        \| endfor
        \| else
        \| exe '<mods> make<bang>' . expand('%')

  command! -bar -nargs=1 -complete=history RerunLastX call histget(<args>, 1)

  " from the help
  " Define an Ex command ":H {num}" that supports re-execution of the {num}th entry from the output of |:history|. >
  command! -nargs=1 -bar -complete=history H execute histget("cmd", 0+<args>)

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
  command! -complete=dir -nargs=1 -bar -bang Mkdir call mkdir(<q-args>, 'p', '0700')

  " From `:he change`  line 352 tag g?g?
  " Adding range means that the command defaults to current line
  " Need to add a check that we're in visual mode and drop the '<,'> if not.
  command! -bar -range TitleCase execute 'normal! ' . "'<,'>s/\v<(.)(\w*)/\u\1\L\2/g"

  " Chalk this up to *Things that I couldnt believe werent already commands*
  command! -bar Ruler normal! g<C-g>

" UltiSnips:
  function! UltiSnipsConf() abort

    let g:UltiSnipsExpandTrigger = '<Tab>'
    let g:UltiSnipsJumpForwardTrigger= '<Tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    let g:ultisnips_python_style = 'numpy'
    let g:ultisnips_python_quoting_style = 'double'
    let g:UltiSnipsEnableSnipMate = 0
    " context is an interesting option. it's a vert split unless textwidth <= 80
    let g:UltiSnipsEditSplit = 'context'
    let g:snips_author = 'Faris Chugthai'
    let g:snips_github = 'https://github.com/farisachugthai'
    " Defining it and limiting it to 1 directory means that UltiSnips doesn't
    " iterate through every dir in &rtp which saves an immense amount of time
    " on startup.
    let g:UltiSnipsSnippetDirectories = [ expand('$HOME') . '/.config/nvim/UltiSnips' ]
    let g:UltiSnipsUsePythonVersion = 3
    let g:UltiSnipsListSnippets = '<C-/>'
    if !exists('*stdpath')
      return
    endif
    " Wait is this option still a thing??
    let g:UltiSnipsSnippetDir = [stdpath('config') . '/UltiSnips']
  endfunction

  call UltiSnipsConf()

  " In case you're wondering about this, ultisnips requires python from vim.
  " however neovim has it's python interation set up externally. so when i manage
  " to fuck it up, ultisnips breaks. so i need to be able to disable it and then
  " re-enable it when the python integration is fixed

" Python:
  " Pydoc:
    " endif

    command! -bar -complete=expression -complete=function -range -nargs=+ Pythonx <line1>,<line2>python3 <args>
    " FUCK YEA! Dec 27, 2019: Behaves as expected!
    " You know whats nice? Both of these expressions work.
    " :Pd(vim.vars)
    " :Pd vim.vars
    command! -range -bar -complete=expression -complete=function -nargs=? Pd <line1>,<line2>python3 from pprint import pprint; pprint(dir(<args>))


    " Js the original implementation should ALSO complete files or dirs
    command! -range=% -bar -bang -complete=dir -complete=buffer -addr=loaded_buffers -nargs=* Py3f :<line1>,<line2>py3f <args>
    command! -range=% -bar -bang -complete=dir -complete=buffer -addr=loaded_buffers -nargs=* Py3 :<line1>,<line2>py3 <args>

    command! -range -bar -complete=file -complete=dir -nargs=* Pyf  :<line1>,<line2>pyf  <args>

    command! -range -bar -complete=expression -complete=function -nargs=? P <line1>,<line2>python3 print(<args>)

    command! -range -bar -complete=expression -complete=function -nargs=? Pv <line1>,<line2>python3 print(vars(<args>))

    command! -bar -range -nargs=+ Pi <line1>,<line2>python3 import <args>

    command! -bang -bar PydocThis call pydoc_help#PydocCword(<bang>0, expand(<cword>))

    " This should be able to take the argument '-bang' and allow to open in a new
    " separate window like fzf does.
    " NOTE: See :he func-range to see how range can get passed automatically to
    " functions without being specified in the command definition

    function! s:PythonMods(A, L, P) abort
      " this doesnt work? py3do can only return a  str or None which sucks since wed prefer a list.
      " Also jesus why does this write the return value to the buffer?
      let s:ret = py3eval(sys.modules)
      return s:ret
    endfunction

    " TODO: get this complete
    " command! -range -bang -nargs=? -bar -complete=custom,s:PythonMods Pydoc call pydoc_help#Pydoc(<f-args>, <bang>0, <mods>)

    " Doesnt work AGAIN
    " command! -bang -nargs=* -bar Pydoc call pydoc_help#Pydoc(<bang>, expand('<cfile>'))
    command! -bar -bang Pydoc call pydoc_help#async_cursor()

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

  " General Python Commands:
    " If things slow down autoload these.
    command! -bar Black call py#Black()
    command! -bar BlackUpgrade call py#BlackUpgrade()
    command! -bar BlackVersion echo py#black_version()

    " TODO: Work on the range then the bang
    command! -bar -complete=file -range BlackCurrent <line1>,<line2>call py#Black()

    command! -nargs=+ -bar -complete=buffer -range -addr=buffers -complete=file_in_path BlackThese call py#black_these(<f-args>)

    function! s:IPythonOptions(...) abort
      let l:list = ['profile', 'history', 'kernel', 'locate']
      " Quote this with single quotes and it wont work correctly...WHAT THE FUCK
      return join(l:list, "\n")
    endfunction

    " So far works
    command! -bar -bang -nargs=* -complete=dir -complete=custom,s:IPythonOptions IPy :<mods>term<bang> ipython <args>

    command! -bar -bang -complete=buffer ScratchBuffer call pydoc_help#scratch_listed_buffer(<bang>0)

    command! -nargs=* -bar -bang Pynvim call py#Cnxn(<bang>0, <args>)
    command! -nargs=* -bar -bang PyChannel call py#Yours(<bang>0, <args>)
    " Add a platform check in that file so we can have 1 entry point
    command! -bar RemoteReload call remotes#msdos_remote()


  " More From The Bottom Of Help Map:
  command! -bang -bar -nargs=+ -complete=file -complete=file_in_path EditFiles
      \ for f in expand(<q-args>, 0, 1) |
      \ exe '<mods> split ' . f<bang> |
      \ endfor

  command! -bar -range -nargs=* -complete=file Snew call unix#SpecialEdit(<q-args>, <q-mods>)

  command! -complete=filetype -bar UltiSnipsListSnippets call UltiSnips#ListSnippets()

" Learn Complete:
  " Note that you haven't to provide nargs or typing a letter with stop the completion
  command! -bar -bang -complete=compiler -nargs=1 Compiler compiler<bang> <args>
  " '<,'>s/compiler/event/g
  " You may find that ---^ does you good
  command! -bar -complete=event Event event<args>

  command! -bar -bang -complete=var -nargs=+ Var set<bang> <args>

  " Well check out how cool this is. shouldnt be so surprised that this works
  command! -complete=environment -bar -nargs=+ Env let $<args>

  command! -bar Redo call histget('cmd', -1)

  " Commands from the help pages. map.txt:
  " Replace a range with the contents of a file
  command! -bar -range -nargs=1 -complete=file Replace <line1>-pu_|<line1>,<line2>d|r <args>|<line1>d

  " Count the number of lines in the range.
  command! -bar -range -nargs=* Lines echomsg <line2> - <line1> + 1 'lines'

  if !empty($ANDROID_DATA)
    command! -bang TermuxSend :silent! keepalt w<bang> <bar>exec '!termux-share -a send ' . expand('%:S')
    nnoremap <Leader>ts <Cmd>TermuxSend<CR>
  endif

  if !has('unix')
    command! SetCmd call msdos#set_shell_cmd()
    command! -bar -nargs=? CmdInvoke call msdos#invoke_cmd(<f-args>)
    command! -bar -nargs=? -complete=shellcmd Cmd call msdos#CmdTerm(<f-args>)
    command! PowerShell call msdos#PowerShell()
    command! -bar -nargs=? PwshHelp call msdos#pwsh_help(shellescape(<f-args>))
  endif

" Fugitive Functions:
  " If it hasnt been, source fugitive.
  if !exists('g:autoloaded_fugitive')
    source $HOME/.local/share/nvim/plugged/vim-fugitive/autoload/fugitive.vim
  endif

  function! s:get_git_root()
    let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
    return v:shell_error ? '' : root
  endfunction

  function s:ProjectGitDir() abort
    let root = s:get_git_root()
    if empty(root)
      return s:warn('Not in git repo')
    endif
    " Like how would this not be really useful all the time?
    return FugitiveExtractGitDir(fnamemodify(expand('%'), ':p:h'))
  endfunction

  function ProjectRoot() abort
    return fnamemodify(fnameescape(s:ProjectGitDir()), ':p:h')
  endfunction

  command! -range=% -addr=buffers -bang -bar GRoot echo ProjectRoot()

  " XXX: might not be the right complete
  command! -complete=customlist,fugitive#ReadComplete -range -addr=arguments -bang -bar -nargs=* Gclone exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)

  command! -bar GHead call plugins#fugitive_head()

  command! -complete=customlist,fugitive#ReadComplete -range -addr=arguments -bang -nargs=* Gds2 :enew<bang><bar>exec 'Gread! ' . <q-args> ==# '' ? 'diff --staged --stat HEAD' : <q-args> . ' -- .'<bar>set filetype=git

  if !has('unix')
    " TODO: how to add --renormalize as an arg every write command
    " only getting this problem on windows from line endings
    exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gw     exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'
    exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gwrite exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'
    exe 'command! -bar -bang -nargs=* -complete=customlist,fugitive#EditComplete Gwq    exe fugitive#WqCommand(   <line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])'
  endif

" Syntax Highlighting:
  command! HL call syncom#HL()
  command! HiC call syncom#HiC()
  command! HiQF call syncom#HiQF()
  command! SyntaxInfo call syncom#get_syn_info()
  " Works:
  command! HiTest call syncom#hitest()

  function! s:CompleteSynInclude(A, L, P) abort
    return globpath(&rtp, "syntax/**/*.vim", 0, 1)
  endfunction

  " Its annoying that syn include doesnt complete paths
  " Now it does!
  command! -nargs=? -bar -complete=customlist,s:CompleteSynInclude SyntaxInclude syntax include <args>

  " note that this doesnt work.
  " command! -nargs=1 -bar -complete=syntax SyntaxIncludeBuiltin syntax include <args>
