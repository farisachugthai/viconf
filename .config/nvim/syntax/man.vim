" Vim syntax file
" Language:         Man page syntax highlighting
" Maintainer:       Faris Chugthai
" Latest Revision:  2018-11-03
" Previous Maintainers:       SungHyun Nam <goweol@gmail.com>
"                             Anmol Sethi <anmol@aubble.com>


" There needs to be more highlight groups bexause everything ends up red
" From $VIMRUNTIME/syntax/man.vim
" syntax match manSectionHeading display '^\S.*$'
" That's insane! The line decides a full line is a section heading.
" I hate vims regexs so we'll need to figure that out some other way.

if exists("b:current_syntax")
  finish
endif

highlight manSectionHeading guifg='LightCyan'

" However I'm seriously considering reading in the vimruntime one and
" rewriting it. Actually

" Let's do it.
" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syntax case  ignore
syntax match manReference       '\<\zs\(\f\|:\)\+(\([nlpo]\|\d[a-z]*\)\?)\ze\(\W\|$\)'
syntax match manTitle           '^\(\f\|:\)\+([0-9nlpo][a-z]*).*'
syntax match manSectionHeading  '^[a-z][a-z0-9& ,.-]*[a-z]$'
syntax match manHeaderFile      '\s\zs<\f\+\.h>\ze\(\W\|$\)'
syntax match manURL             `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]`
syntax match manEmail           '<\?[a-zA-Z0-9_.+-]\+@[a-zA-Z0-9-]\+\.[a-zA-Z0-9-.]\+>\?'
syntax match manHighlight       +`.\{-}''\?+

" So here are the group Vim has and how they defined them
" syn match  manReference       "\f\+([1-9][a-z]\=)"
" syn match  manTitle	      "^\f\+([0-9]\+[a-z]\=).*"
" syn match  manSectionHeading  "^[a-z][a-z -]*[a-z]$"
" syn match  manSubHeading      "^\s\{3\}[a-z][a-z -]*[a-z]$"
" syn match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
" syn match  manLongOptionDesc  "^\s*--[a-z0-9-]\S*"
" syn match  manHistory		"^[a-z].*last change.*$"

syntax match manFile       display '\s\zs\~\?\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax match manEnvVarFile display '\s\zs\$[0-9A-Za-z_{}]\+\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax region manFiles     start='^FILES'hs=s+5 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manFile,manEnvVarFile

syntax match manEnvVar     display '\s\zs\(\u\|_\)\{3,}' contained
syntax region manFiles     start='^ENVIRONMENT'hs=s+11 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manEnvVar

" Add in syntax groups for C style man pages
if getline(1) =~ '^[a-zA-Z_]\+([23])'
  syntax include @cCode <sfile>:p:h/c.vim
  syn match manCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained
  syn region manSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=manSectionHeading,@cCode,manCFuncDefinition
endif


" Nvim's highlighting pattern with longopt and CFunc from Vim.
" Defines the default highlighting only when that item doesn't already have
" a highlighting group.
highlight default link manTitle          Title
highlight default link manSectionHeading Statement
highlight default link manOptionDesc     Constant
highlight default link manLongOptionDesc Constant
highlight default link manReference      PreProc
highlight default link manSubHeading     Function
highlight default link manCFuncDefinition Function

highlight default manUnderline cterm=underline gui=underline
highlight default manBold      cterm=bold      gui=bold
highlight default manItalic    cterm=italic    gui=italic

" why would you do this???
" if &filetype != 'man'
"   " May have been included by some other filetype.
"   finish
" endif

" below syntax elements valid for manpages 2 & 3 only
" TODO: Some groups are defied 2 times.
if !exists('b:man_sect')
  call man#init_pager()
endif
if b:man_sect =~# '^[023]'
  syntax case match
  syntax include @c $VIMRUNTIME/syntax/c.vim
  syntax match manCFuncDefinition display '\<\h\w*\>\ze\(\s\|\n\)*(' contained
  syntax match manSentence display '\%(^ \{3,7}\u\|\.  \u\)\_.\{-}
        \\%(-$\|\.$\|:$\)\|
        \ \{3,7}\a.*\%(\.\|:\)$' contained contains=manReference
  syntax region manSynopsis start='^\%(
        \SYNOPSIS\|
        \SYNTAX\|
        \SINTASSI\|
        \SKŁADNIA\|
        \СИНТАКСИС\|
        \書式\)$' end='^\%(\S.*\)\=\S$' keepend contains=manSentence,manSectionHeading,@c,manCFuncDefinition
  highlight default link manCFuncDefinition Function

  syntax region manExample start='^EXAMPLES\=$' end='^\%(\S.*\)\=\S$' keepend contains=manSentence,manSectionHeading,manSubHeading,@c,manCFuncDefinition

  " XXX: groupthere doesn't seem to work
  syntax sync minlines=500
  "syntax sync match manSyncExample groupthere manExample '^EXAMPLES\=$'
  "syntax sync match manSyncExample groupthere NONE '^\%(EXAMPLES\=\)\@!\%(\S.*\)\=\S$'

  syntax match manCFuncDefinition  display '\<\h\w*\>\s*('me=e-1 contained
  syntax match manCError           display '^\s\+\[E\(\u\|\d\)\+\]' contained
  syntax match manSignal           display '\C\<\zs\(SIG\|SIG_\|SA_\)\(\d\|\u\)\+\ze\(\W\|$\)'
  syntax region manSynopsis start='^\(LEGACY \)\?SYNOPSIS'hs=s+8 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSectionHeading,@cCode,manCFuncDefinition,manHeaderFile
  syntax region manErrors   start='^ERRORS'hs=s+6 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSignal,manReference,manSectionHeading,manHeaderFile,manCError
endif

" Prevent everything else from matching the last line
execute 'syntax match manFooter display "^\%'.line('$').'l.*$"'

let b:current_syntax = 'man'
