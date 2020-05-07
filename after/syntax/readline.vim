
syn keyword readlineFunction  self-insert digit-argument vi-append-eol yank-last-arg
      \ accept-line vi-subst vi-subst vi-undo vi-undo vi-char-search
      \ vi-char-search vi-char-search vi-char-search vi-char-search
      \ yank-pop vi-column vi-complete vi-yank-to vi-yank-to vi-match
      \ character-search vi-prev-word vi-prev-word vi-search-again
      \ vi-search-again beginning-of-line backward-kill-line kill-line
      \ tilde-expand kill-region menu-complete prefix-meta end-kbd-macro
      \ set-mark vi-redo next-history yank vi-end-word vi-end-word
      \ vi-replace dump-variables redraw-current-line undo upcase-word
      \ vi-goto-mark complete backward-delete-char print-last-kbd-macro
      \ menu-complete-backward vi-change-case kill-whole-line
      \ unix-filename-rubout beginning-of-history yank-nth-arg
      \ insert-comment start-kbd-macro exchange-point-and-mark
      \ non-incremental-forward-search-history re-read-init-file
      \ vi-append-mode vi-arg-digit dump-macros do-uppercase-version
      \ skip-csi-sequence call-last-kbd-macro kill-word vi-editing-mode
      \ quoted-insert vi-movement-mode forward-word backward-word
      \ clear-screen downcase-word tab-insert
      \ non-incremental-reverse-search-history copy-region-as-kill
      \ unix-word-rubout delete-char overwrite-mode transpose-chars
      \ copy-forward-word transpose-words history-search-forward
      \ forward-char vi-put vi-put backward-char revert-line
      \ backward-kill-word previous-history unix-line-discard vi-eof-maybe
      \ vi-search character-search-backward vi-set-mark capitalize-word
      \ end-of-history history-search-backward vi-insert-mode vi-delete-to
      \ vi-delete-to vi-yank-arg vi-tilde-expand vi-next-word vi-next-word
      \ vi-insert-beg delete-horizontal-space insert-completions
      \ possible-completions emacs-editing-mode end-of-line vi-change-char
      \ dump-functions vi-fetch-history vi-change-to vi-change-to
      \ reverse-search-history vi-first-print delete-char-or-list
      \ forward-backward-delete-char vi-delete universal-argument abort
      \ copy-backward-word forward-search-history 


syn keyword readlineNewFunction edit-and-execute-command bracketed-paste-begin
      \ shell-expand-line magic-space glob-list-expansions  glob-expand-word
      \ glob-complete-word complete-variable complete-command complete-filename
      \ complete-hostname complete-into-braces complete-username complete-variable
      \ display-shell-version dynamic-complete-history insert-last-argument
      \ possible-filename-completions possible-hostname-completions
      \ possible-username-completions possible-variable-completions
      \ possible-command-completions

hi link readlineNewFunction Function
