" ============================================================================
    " File: ruby.vim
    " Author: Faris Chugthai
    " Description: ruby ftplugin
    " Last Modified: May 12, 2020
" ============================================================================

if exists('b:did_ftplugin') | finish | endif

" ******
" BUG
" ******
" This is in the offical nvim ftplugin. nvim doesn't even have balloonexpr

" To activate, :set ballooneval
" if exists('+balloonexpr') && get(g:, 'ruby_balloonexpr')
"   setlocal balloonexpr=RubyBalloonexpr()
"   let b:undo_ftplugin .= "| setl bexpr="
" endif

let g:ruby_version_paths = {}

let g:ruby_recommended_style = 1

" Don't make this device specific
if exists('$RUBYLIB')
  let g:ruby_default_path = map(split($RUBYLIB,':'), 'v:val ==# "." ? "" : v:val')
else
  " ***
  " BUG:
  " ***
  " If this isn't a list, then setting g:ruby_host_prog raises. which is outrageously fucking
  " annoying
  " Like i feel like it's too obvious that their ftplugin got copied from tpope
  if exists('$GEM_PATH')
    let g:ruby_default_path = [expand("$GEM_PATH"), '']
  endif
endif


" Dude how do we avoid sourcing his version
setlocal omnifunc=rubycomplete#Complete
source $VIMRUNTIME/ftplugin/ruby.vim

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
                      \. '|setlocal '
                      \. '|unlet! b:undo_ftplugin'
                      \. '|unlet! b:did_ftplugin'
