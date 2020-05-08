" The readline functions look outdated so let's help
" Also. Can we PLEASE split this into emacs and vi?
" It'd make my life so much easier

if exists('b:after_syntax_readline') | finish | endif
let b:after_syntax_readline = 1

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
                              \ previous-history
                              \ next-history
                              \ beginning-of-history
                              \ end-of-history
                              \ reverse-search-history
                              \ forward-search-history
                              \ non-incremental-reverse-search-history
                              \ non-incremental-forward-search-history
                              \ history-search-forward
                              \ history-search-backward
                              \ yank-nth-arg
                              \ yank-last-arg

syn keyword readlineInsertionFunction contained
                              \ quoted-insert
                              \ tab-insert
                              \ self-insert
                              \ transpose-chars
                              \ transpose-words
                              \ upcase-word
                              \ downcase-word
                              \ capitalize-word
                              \ overwrite-mode

syn keyword readlineDeletionFunction contained
                              \ delete-char
                              \ backward-delete-char
                              \ forward-backward-delete-char
                              \ kill-line
                              \ backward-kill-line
                              \ unix-line-discard
                              \ kill-whole-line
                              \ kill-word
                              \ backward-kill-word
                              \ unix-word-rubout
                              \ unix-filename-rubout
                              \ delete-horizontal-space
                              \ kill-region
                              \ copy-region-as-kill

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
                              \
                              \ start-kbd-macro
                              \ end-kbd-macro
                              \ call-last-kbd-macro
                              \ print-last-kbd-macro
                              \
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
                              \ vi-change-case
                              \ vi-change-char
                              \ vi-change-to
                              \ vi-change-to
                              \ vi-char-search
                              " \ What the fuck happened here 
                              " \ vi-char-search
                              " \ vi-char-search
                              " \ vi-char-search
                              " \ vi-char-search
                              \ vi-column
                              \ vi-complete
                              \ vi-delete
                              " \ vi-delete-to
                              \ vi-delete-to
                              " \ vi-end-word
                              \ vi-end-word
                              \ vi-eof-maybe
                              \ vi-fetch-history
                              \ vi-first-print
                              \ vi-goto-mark
                              \ vi-insert-beg
                              \ vi-insert-mode
                              \ vi-match
                              \ vi-movement-mode
                              " \ vi-next-word
                              \ vi-next-word
                              " \ vi-prev-word
                              \ vi-prev-word
                              \ vi-put
                              " \ vi-put
                              \ vi-redo
                              \ vi-replace
                              \ vi-search
                              \ vi-search-again
                              " \ vi-search-again
                              \ vi-set-mark
                              \ vi-subst
                              \ vi-subst
                              \ vi-tilde-expand
                              \ vi-undo
                              " \ vi-undo
                              \ vi-yank-arg
                              " \ vi-yank-to
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
