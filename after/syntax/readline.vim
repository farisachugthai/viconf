" The readline functions look outdated so let's help
" Also. Can we PLEASE split this into emacs and vi?
" It'd make my life so much easier

if exists('b:after_syntax_readline') | finish | endif
let b:after_syntax_readline = 1


syn match readlineComment '#.*$'

syn keyword readlineMovementFunction    contained
                              \ beginning-of-line
                              \ end-of-line
                              \ forward-char
                              \ backward-char
                              \ forward-word
                              \ backward-word
                              \ clear-screen
                              \ redraw-current-line

syn keyword readlineHistoryFunction contained
                              \ accept-line
                              \ beginning-of-history
                              \ end-of-history
                              \ forward-search-history
                              \ history-search-backward
                              \ history-search-forward
                              \ next-history
                              \ non-incremental-forward-search-history
                              \ non-incremental-reverse-search-history
                              \ previous-history
                              \ reverse-search-history
                              \ yank-last-arg
                              \ yank-nth-arg

syn keyword readlineInsertionFunction contained
                              \ capitalize-word
                              \ downcase-word
                              \ overwrite-mode
                              \ quoted-insert
                              \ self-insert
                              \ tab-insert
                              \ transpose-chars
                              \ transpose-words
                              \ upcase-word

syn keyword readlineDeletionFunction contained
                              \ backward-delete-char
                              \ backward-kill-line
                              \ backward-kill-word
                              \ copy-region-as-kill
                              \ delete-char
                              \ delete-horizontal-space
                              \ forward-backward-delete-char
                              \ kill-line
                              \ kill-region
                              \ kill-whole-line
                              \ kill-word
                              \ unix-filename-rubout
                              \ unix-line-discard
                              \ unix-word-rubout

syn keyword readlineMiscellaneousFunction contained
                              \ copy-backward-word
                              \ copy-forward-word
                              \ yank
                              \ yank-pop
                              \ digit-argument
                              \ universal-argument
                              \ complete
                              \ possible-completions
                              \ insert-completions
                              \ menu-complete
                              \ menu-complete-backward
                              \ delete-char-or-list
                              \ start-kbd-macro
                              \ end-kbd-macro
                              \ call-last-kbd-macro
                              \ print-last-kbd-macro
                              \ re-read-init-file
                              \ abort
                              \ do-uppercase-version
                              \ prefix-meta
                              \ undo
                              \ revert-line
                              \ tilde-expand
                              \ set-mark
                              \ exchange-point-and-mark
                              \ character-search
                              \ character-search-backward
                              \ skip-csi-sequence
                              \ insert-comment
                              \ dump-functions
                              \ dump-variables
                              \ dump-macros
                              \ emacs-editing-mode
                              \ vi-editing-mode

syn keyword readlineViFunction contained
                              \ vi-append-eol
                              \ vi-append-mode
                              \ vi-arg-digit
                              \ vi-backward-bigword
                              \ vi-backward-word
                              \ vi-change-case
                              \ vi-change-char
                              \ vi-change-to
                              \ vi-change-to
                              \ vi-char-search
                              \ vi-column
                              \ vi-complete
                              \ vi-delete
                              \ vi-delete-to
                              \ vi-end-word
                              \ vi-eof-maybe
                              \ vi-fetch-history
                              \ vi-first-print
                              \ vi-forward-bigword
                              \ vi-forward-word
                              \ vi-goto-mark
                              \ vi-insert-beg
                              \ vi-insert-mode
                              \ vi-match
                              \ vi-movement-mode
                              \ vi-next-word
                              \ vi-prev-word
                              \ vi-put
                              \ vi-redo
                              \ vi-rubout
                              \ vi-replace
                              \ vi-search
                              \ vi-search-again
                              \ vi-set-mark
                              \ vi-subst
                              \ vi-subst
                              \ vi-tilde-expand
                              \ vi-undo
                              \ vi-yank-arg
                              \ vi-yank-to

syn keyword readlineBashFunction  contained
                              \ alias-expand-line
                              \ complete-command
                              \ complete-filename
                              \ complete-hostname
                              \ complete-into-braces
                              \ complete-username
                              \ complete-variable
                              \ dabbrev-expand
                              \ delete-char-or-list
                              \ display-shell-version
                              \ dynamic-complete-history
                              \ edit-and-execute-command
                              \ forward-backward-delete-char
                              \ glob-complete-word
                              \ glob-expand-word
                              \ glob-list-expansions
                              \ history-and-alias-expand-line
                              \ history-expand-line
                              \ insert-last-argument
                              \ magic-space
                              \ operate-and-get-next
                              \ possible-command-completions
                              \ possible-filename-completions
                              \ possible-hostname-completions
                              \ possible-username-completions
                              \ possible-variable-completions
                              \ shell-backward-kill-word
                              \ shell-backward-word
                              \ shell-expand-line
                              \ shell-forward-word
                              \ shell-kill-word

hi link readlineMovementFunction readlineFunction
hi link readlineMiscellaneousFunction readlineFunction
hi link readlineHistoryFunction readlineFunction
hi link readlineInsertionFunction readlineFunction
hi link readlineDeletionFunction readlineFunction
hi link readlineViFunction readlineFunction
hi link readlineBashFunction readlineFunction

" Also because idk what this was defined to but
hi! link readlineEq Delimiter


" Add a new highlighting group for the groups added if g:readline_has_bash is set
syn keyword readlineNewFunction
      \ edit-and-execute-command
      \ bracketed-paste-begin
      \ shell-expand-line
      \ magic-space
      \ glob-list-expansions
      \ glob-expand-word
      \ glob-complete-word
      \ complete-variable
      \ complete-command
      \ complete-filename
      \ complete-hostname
      \ complete-into-braces
      \ complete-username
      \ complete-variable
      \ display-shell-version
      \ dynamic-complete-history
      \ insert-last-argument
      \ possible-filename-completions
      \ possible-hostname-completions
      \ possible-username-completions
      \ possible-variable-completions
      \ possible-command-completions

hi default link readlineNewFunction Function

