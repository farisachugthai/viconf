" Vim syntax file
" Language:	Info file
" Maintainer:	Faris Chugthai
" Last Change:	May 14, 2020

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn include $VIMRUNTIME/syntax/help.vim


" syn match helpSectionDelim	"^===.*===$"
" syn match helpSectionDelim	"^---.*--$"

syn match infoSectionDelim      '^\*\*\*.*\*\*\*$'

syn sync fromstart linebreaks=2

hi def link infoSectionDelim	PreProc

let b:current_syntax = "info"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8 sw=2
