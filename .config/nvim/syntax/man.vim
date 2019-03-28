" Language:        Man page syntax highlighting
" Maintainer:      Faris Chugthai
" Latest Revision: Mar 14, 2019
" Previous Maintainers:       SungHyun Nam <goweol@gmail.com>
"                             Anmol Sethi <anmol@aubble.com>

" Additional highlighting by Johannes Tanzler <johannes.tanzler@aon.at>:
"	* manSubHeading
"	* manSynopsis (only for sections 2 and 3)

" The top is neovim's man syntax file isolated.
" Then vim's and mine intermixed.

if exists("b:current_syntax")
  finish
endif

" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syntax case ignore
syntax match manReference       '\<\zs\(\f\|:\)\+(\([nlpo]\|\d[a-z]*\)\?)\ze\(\W\|$\)'
syntax match manTitle           '^\(\f\|:\)\+([0-9nlpo][a-z]*).*'
syntax match manSectionHeading  '^[a-z][a-z0-9& ,.-]*[a-z]$'
syntax match manHeaderFile      '\s\zs<\f\+\.h>\ze\(\W\|$\)'
" Needs fixing. Vint says syntax error and urls don't highlight if >1 line.
syntax match manURL             `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]`
syntax match manEmail           '<\?[a-zA-Z0-9_.+-]\+@[a-zA-Z0-9-]\+\.[a-zA-Z0-9-.]\+>\?'
syntax match manHighlight       +`.\{-}''\?+

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

highlight default link manTitle          Title
highlight default link manSectionHeading Statement
highlight default link manOptionDesc     Constant
highlight default link manReference      PreProc
highlight default link manSubHeading     Function

highlight default manUnderline cterm=underline gui=underline
highlight default manBold      cterm=bold      gui=bold
highlight default manItalic    cterm=italic    gui=italic

if &filetype != 'man'
  " May have been included by some other filetype.
  finish
endif

" So here are the group Vim has and how they defined them
" syn match  manReference       '\f\+([1-9][a-z]\=)'
" syn match  manTitle	      '^\f\+([0-9]\+[a-z]\=).*'
" syn match  manSectionHeading  '^[a-z][a-z -]*[a-z]$'
" syn match  manSubHeading      '^\s\{3\}[a-z][a-z -]*[a-z]$'
syn match  manOptionDesc      '^\s*[+-][a-z0-9]\S*'
syn match  manLongOptionDesc  '^\s*--[a-z0-9-]\S*'
syn match  manHistory		'^[a-z].*last change.*$'

syntax match manFile       display '\s\zs\~\?\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax match manEnvVarFile display '\s\zs\$[0-9A-Za-z_{}]\+\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax region manFiles     start='^FILES'hs=s+5 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manFile,manEnvVarFile

syntax match manEnvVar     display '\s\zs\(\u\|_\)\{3,}' contained

" Is it okay that we have manFiles defined twice?
" Yes it is. If you run `:syn` on a man page both definitions show up
syntax region manFiles     start='^ENVIRONMENT'hs=s+11 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manEnvVar


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
  syntax region manSynopsis start='^\(LEGACY \)\?SYNOPSIS'hs=s+8 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSectionHeading,@cCode,manCFuncDefinition,manHeaderFile
  syntax region manErrors   start='^ERRORS'hs=s+6 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSignal,manReference,manSectionHeading,manHeaderFile,manCError
  syntax match manLowerSentence /\n\s\{7}\l.\+[()]\=\%(\:\|.\|-\)[()]\=[{};]\@<!\n$/ display keepend contained contains=manReference
  syntax region manExample start='^EXAMPLES\=$' end='^\%(\S.*\)\=\S$' keepend contains=manLowerSentence,manSentence,manSectionHeading,manSubHeading,@c,manCFuncDefinition

  syntax sync match manSyncExample groupthere manExample '^EXAMPLES\=$'
  syntax sync match manSyncExample groupthere NONE '^\%(EXAMPLES\=\)\@!\%(\S.*\)\=\S$'

  syntax match manCFuncDefinition  display '\<\h\w*\>\s*('me=e-1 contained
  syntax match manCError           display '^\s\+\[E\(\u\|\d\)\+\]' contained
  syntax match manSignal           display '\C\<\zs\(SIG\|SIG_\|SA_\)\(\d\|\u\)\+\ze\(\W\|$\)'


  hi! link manCFuncDefinition Function
  hi! link manCError Error
  hi! link manErrors Error
  hi! link manLowerSentence String
  hi! link manSignal Type
  hi! link manSynopsis Title

endif

" Nvim's highlighting pattern with longopt and CFunc from Vim.
" Defines the default highlighting only when that item doesn't already have
" a highlighting group.
hi! link manLongOptionDesc Constant
hi! link manSentence       String

" Prevent everything else from matching the last line
execute 'syntax match manFooter display "^\%'.line('$').'l.*$"'
" Wait why. Usually those include links to other man pages,
" not only do I want those highlighted I want extra funcs for them

if g:colors_name ==# 'gruvbox'
    hi! link manCError GruvboxRed
    hi! link manEmail GruvboxAqua
    hi! link manEnvVar GruvboxBlue
    hi! link manEnvVarFile GruvboxBlue
    hi! link manFile GruvboxYellow
    hi! link manFiles GruvboxFg0
    hi! link manFooter GruvboxPurple
    hi! link manHighlight GruvboxYellow
    hi! link manHistory GruvboxYellow
    hi! link manHeaderFile GruvboxYellow
    hi! link manSectionHeading GruvboxOrangeBold
    hi! link manSentence GruvboxFg2
    hi! link manSignal GruvboxPurple
    hi! link manURL GruvboxGreen
endif

" Mar 14, 2019
" manCFuncDefinition xxx cleared
" manSignal      xxx cleared


let b:current_syntax = 'man'
