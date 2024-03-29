;;; Main emacs init file, .emacs 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add HOME and HOME/emacs to load-path
(setq load-path (append load-path (list "~/emacs")))
(setq load-path (append load-path (list (getenv "HOME"))))

;; Requires > 24.3
(if (or (and (= emacs-major-version 24)
	     (>= emacs-minor-version 3))
	(> emacs-major-version 24))
    (if (require 'benchmark-init-loaddefs nil t)
        (benchmark-init/activate)))

(require 'dired)

;; Let shell know that it's running in Emacs
(setenv "EMACS_SH" "t")

;; Functions to determine environment
(defun is-windows ()
  "Checks in case environment is Windows"
  (interactive)
  (string-match "Windows" (or (getenv "OS") (getenv "OSTYPE") "")))

(defun is-unix ()
  "Checks in case environment is Unix"
  (not (is-windows)))

(defun is-xemacs ()
  "Checks in case Xemacs"
  (string-match "XEmacs" emacs-version))

(defun is-emacs ()
  "Checks in case Emacs"
  (not (is-xemacs)))

;; Some version related issues
(load ".emacs_versions")

;; Set default values
(setq-default confirm-kill-emacs 'yes-or-no-p)
(setq-default inhibit-default-init 1)
(setq-default next-line-add-newlines nil)
(setq-default mouse-yank-at-point 1)
(setq-default visible-bell 1)
(setq-default track-eol 1)
(setq-default indent-tabs-mode nil)
(setq-default blink-matching-paren-on-screen 1)
(setq-default scroll-step 1)
(setq-default scroll-conservatively 1000)
(setq-default line-number-mode 1)
(setq-default column-number-mode 1)
(setq-default which-func-maxout 0)
(setq-default enable-local-variables nil)
;;(setq-default frame-title-format '(buffer-file-name (-80 . "%f") "%b"))
(setq-default frame-title-format '(:eval (my-get-frame-title)))
(setq-default comment-padding 0)
(setq-default auto-save-default nil)
(setq-default auto-save-timeout nil)
(setq-default auto-save-interval 0)
(setq-default fill-column 80)
(setq-default ediff-window-setup-function 'ediff-setup-windows-plain)
(setq-default imenu-always-use-completion-buffer-p 'never)
(setq-default browse-url-browser-function 'browse-url-text-emacs)
(setq-default find-file-visit-truename 1)
(setq-default comint-input-ring-size 500)
(setq-default term-input-ring-size 500)
(setq-default term-buffer-maximum-size 0)
(setq-default term-default-bg-color nil)
(setq-default term-default-fg-color nil)
(setq-default comint-completion-addsuffix '("/" . ""))
(setq-default term-completion-addsuffix '("/" . ""))
(setq-default dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
(setq-default grep-use-null-device t)
(setq-default password-cache-expiry nil)
(setq-default ispell-program-name "hunspell")
(setq-default x-select-enable-primary t)
(setq-default select-active-regions nil)
(setq-default mouse-drag-copy-region t)
(setq-default Man-notify-method 'bully)
;; Why did I add this? -f prohipts aliases to work...
;;(setq-default shell-command-switch "-fc")
;;(setq-default show-trailing-whitespace t)
;;(setq-default indicate-empty-lines t)
(setq-default require-final-newline t)
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
(setq whitespace-style (list `face `tabs `space-before-tab `space-after-tab `tab-mark `empty))
;(setq-default debug-on-error t)
(make-variable-buffer-local 'adaptive-fill-mode)

;; Remove some ignored completion extensions
(delete "~"    completion-ignored-extensions)
(delete ".log" completion-ignored-extensions)

;; Postscript printing
(setq-default ps-lpr-command "lpr")
(setq-default ps-line-number t)
(setq-default ps-paper-type 'a4)
(setq-default ps-font-size 6)
(setq-default ps-print-color-p nil)
(setq-default ps-print-header t)
(setq-default ps-landscape-mode t)
(setq-default ps-number-of-columns 2)
(setq-default ps-spool-duplex t)

(when (require 'ipa nil t)
  (setq-default ipa-overlay-position "below")
  (setq-default ipa-file "/proj/sgsn_rest/work/ervjest/.ipa")
  (add-hook 'ipa-mode-hook (lambda () (auto-revert-mode t)))
  )

(defun decode-ipa ()
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "^ +" nil t)
    (replace-match ""))
  (goto-char (point-min))
  (while (re-search-forward "^(pos.+:line" nil t)
    (replace-match "line")))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Always "y" or "n" instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)
(if (boundp 'use-short-answers) (setq-default use-short-answers t))

;; Key Bindings
(global-set-key   "\C-k"              'my-kill-whole-line)
(global-set-key   "\C-xg"             'grep)
(global-set-key   "\e\C-xg"           'grep-find)
(global-set-key   "\eg"               'goto-line)
(global-set-key   "\C-xd"             'gdb)
(global-set-key   "\t"                'indent-according-to-mode)
(global-set-key   "\C-c\C-c"          'comment-region)
(global-set-key   [end]               'end-of-line)
(global-set-key   [home]              'beginning-of-line)
(global-set-key   "\ee"               'forward-sexp)
(global-set-key   "\ea"               'backward-sexp)
(global-set-key   "\C-xm"             'my-compile)
(global-set-key   [delete]            'delete-char)
(global-set-key   [backspace]         'delete-backward-char)
(global-set-key   [(control return)]  'my-find-file-at-point)
(global-set-key   [(control tab)]     'dabbrev-expand)
(global-set-key   "\C-s"              'isearch-forward-regexp)
(global-set-key   "\C-r"              'isearch-backward-regexp)
(global-set-key   "\e\045"            'query-replace-regexp)
(global-set-key   "\en"               'next-error)
(global-set-key   "\ep"               'previous-error)
(global-set-key   "\ep"               'previous-error)
(global-set-key   [(C-kp-add)]        'text-scale-adjust)
(global-set-key   [(C-kp-subtract)]   'text-scale-adjust)
(global-set-key   [(C-kp-zero)]       'text-scale-adjust)
(global-unset-key "\C-t")


;; My hooks

;; Fix so tab defaults to 'completion-at-point in minibuffer.
(add-hook 'minibuffer-setup-hook
          (lambda ()
            (if (eq 'self-insert-command (lookup-key (current-local-map) "	"))
                (let ((my-map (make-keymap "my-minibuffer-map")))
                  (define-key my-map [tab] 'completion-at-point)
                  (set-keymap-parent my-map (current-local-map))
                  (use-local-map my-map)
                  )
              )
            (turn-off-auto-fill)
            )
          1)
(define-key minibuffer-local-map [(control tab)] 'scroll-other-window)

(defun my-read-only-mode-hook ()
  (setq show-trailing-whitespace (not buffer-read-only)))

(add-hook 'read-only-mode-hook 'my-read-only-mode-hook t)
(add-hook 'find-file-hook 'my-read-only-mode-hook t)

; Shell mode
(require 'comint)
(defun my-shell-mode-hook ()
  (local-set-key [(control tab)] 'dabbrev-expand)
  (local-set-key "\C-c"          'comint-interrupt-subjob)

  (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m t t)

  (setq comint-prompt-regexp "^[^#$%>\n]*[#$%>]")
  (set-process-query-on-exit-flag (get-buffer-process (buffer-name)) nil)
  (if (is-windows)
      (progn
        (setq-local shell-dirstack-query "cd")
        (setq-local comint-process-echoes t)
        (setq-local comint-input-ring-file-name "~/.dos_history")
        (comint-read-input-ring))))

(add-hook 'shell-mode-hook 'my-shell-mode-hook t)

(defun my-read-shell-command (prompt &optional initial-value hist)
  (read-from-minibuffer
   prompt
   initial-value
   nil
   nil
   (or hist 'shell-command-history)))

(defun my-shell-command-verbose (command)
  "Execute COMMAND in shell with message. As `shell-command', but possible to
run several jobs simultanously"
  (interactive (list (read-shell-command "Shell command: ")))
  (let ((error-buffer "*Shell Command Error*"))
    (message (concat "Executing: " command " ..."))
    (cond ( (and (functionp 'my-is-git-shell-command) (my-is-git-shell-command command))
            (magit-shell-command command))

          ( t
            (if (string-match "&" command)
                (start-process-shell-command command nil command)
              (if (get-buffer error-buffer) (kill-buffer error-buffer))
              (shell-command command nil error-buffer))
            ;; Bug in emacs 23 - error buffer not displayed...
            (if (get-buffer error-buffer)
                (display-buffer (get-buffer error-buffer)))
            )
          )))

(defalias 'shell-command-verbose 'my-shell-command-verbose)

(global-set-key "\e!" 'shell-command-verbose)

; Shell script mode
(defvar my-sh-script-imenu-generic-expression
  `(
    ;; General function name regexp
    (nil ,"^\\s-*function\\s-+\\([A-Za-z_][A-Za-z_0-9]*\\)" 1)
    (nil ,"^\\s-*\\([A-Za-z_][A-Za-z_0-9]*\\)\\s-*()" 1))

  "Imenu generic expression for `sh-mode'.  See `imenu-generic-expression'.
Copied from `sh-imenu-generic-expression', which seemed faulty.")

(defun my-sh-mode-hook ()
  (local-set-key  "\C-c\C-c"       'comment-region)
  (setq imenu-generic-expression my-sh-script-imenu-generic-expression))

(add-hook 'sh-mode-hook 'my-sh-mode-hook t)

;; Makefile mode
(add-hook 'makefile-mode-hook
          (lambda () (local-set-key "\C-i" 'self-insert-command)))

; Compilation mode
(defun my-compilation-mode-hook ()
  (setq buffer-read-only nil)
  (setq compilation-scroll-output t)

  (local-set-key "\C-g"          'my-stop-process)
  (local-set-key [tab]           'completion-at-point)
  (local-set-key [(control tab)] 'scroll-other-window))

(add-hook 'compilation-mode-hook 'my-compilation-mode-hook t)

; Comint - debugging, shells etc...

(defun my-comint-backward-char ()
"Move point left one character.
On attempt to pass beginning of prompt, stop and signal error."
  (interactive)
  (let ((home-pos (save-excursion (comint-bol nil))))
    (if (not (eq home-pos (point)))
        (backward-char)
      (error "At prompt"))))

(defun my-term-backward-char ()
"Move point left one character.
On attempt to pass beginning of prompt, stop and signal error."
  (interactive)
  (let ((home-pos (save-excursion (term-bol nil))))
    (if (not (eq home-pos (point)))
        (backward-char)
      (error "At prompt"))))

(defun my-comint-delete-backward-char ()
"Delete the previous character. Unless a region is active, in that
case the region is killed instead.
On attempt to pass beginning of prompt, stop and signal error."
  (interactive)
  (if mark-active
      (call-interactively 'delete-region)
    (let ((home-pos (save-excursion (comint-bol nil))))
      (if (not (eq home-pos (point)))
          (delete-char -1)
        (error "At prompt")))))

(defun my-term-delete-backward-char ()
"Delete the previous character. Unless a region is active, in that
case the region is killed instead.
On attempt to pass beginning of prompt, stop and signal error."
  (interactive)
  (if mark-active
      (call-interactively 'delete-region)
    (let ((home-pos (save-excursion (term-bol nil))))
      (if (not (eq home-pos (point)))
          (delete-char -1)
        (error "At prompt")))))

(defun my-comint-move-to-command-line (n)
"Advice function which moves to commmand line in case cursor is elsewhere."
  (interactive "p")
  (if (not (comint-after-pmark-p))
        (goto-char (point-max))))

;;(advice-add 'comint-previous-matching-input-from-input :before #'my-comint-move-to-command-line)
;;(advice-add 'comint-next-matching-input-from-input :before #'my-comint-move-to-command-line)
(defadvice comint-previous-matching-input-from-input
  (before comint-previous-to-cmd-line (n))
  "Move to command line before reading input history - see `my-comint-move-to-command-line'."
  (my-comint-move-to-command-line n))
(ad-activate 'comint-previous-matching-input-from-input)

(defadvice comint-next-matching-input-from-input
  (before comint-next-to-cmd-line (n))
  "Move to command line before reading input history - see `my-comint-move-to-command-line'."
  (my-comint-move-to-command-line n))
(ad-activate 'comint-next-matching-input-from-input)

(defun my-term-move-to-command-line (n)
  "Advice function which moves to commmand line in case cursor is elsewhere."
  (interactive "p")
  (if (not (term-after-pmark-p))
      (goto-char (point-max)))
  ;; Also remove whitespaces in the beginning.
  (let* (
         (p (point))
         (bol (term-bol nil))
         (bol (if bol bol (beginning-of-line) (point)))
         )
    (if (>= (point-max) bol)
        (progn
          (if (re-search-forward "[	 ]+$" nil t)
              (if (eq (match-beginning 0) bol)
                  (replace-match "")))
          ;; Fix prompt if missing...
          (if (not (term-bol nil))
              (progn
                ;; Force prompt
                (term-send-string (get-buffer-process (buffer-name)) "\n")))))
                ;;(my-term-highlight-all-prompts)))))
    (goto-char p)))

;;(advice-add 'term-previous-matching-input-from-input :before #'my-term-move-to-command-line)
;;(advice-add 'term-next-matching-input-from-input :before #'my-term-move-to-command-line)
(defadvice term-previous-matching-input-from-input
  (before term-previous-to-cmd-line (n))
  "Move to command line before reading input history - see `my-term-move-to-command-line'."
  (my-term-move-to-command-line n))
(ad-activate 'term-previous-matching-input-from-input)

(defadvice term-next-matching-input-from-input
  (before term-next-to-cmd-line (n))
  "Move to command line before reading input history - see `my-term-move-to-command-line'."
  (my-term-move-to-command-line n))
(ad-activate 'term-next-matching-input-from-input)

(defvar my-comint-mode nil "Variable indicating if comint-mode is active in current buffer")
(make-variable-buffer-local 'my-comint-mode)

(defvar my-term-shell-mode nil "Variable indicating if term-mode is active in current buffer")
(make-variable-buffer-local 'my-term-shell-mode)

(defun my-comint-mode-hook ()
  (local-set-key [home]                'comint-bol)
  (local-set-key "\C-a"                'comint-bol)
  (local-set-key [up]                  'comint-previous-matching-input-from-input)
  (local-set-key [(control up)]        'previous-line)
  (local-set-key [down]                'comint-next-matching-input-from-input)
  (local-set-key [(control down)]      'next-line)
  (local-set-key [left]                'my-comint-backward-char)
  (local-set-key [backspace]           'my-comint-delete-backward-char)
  (local-set-key [(control backspace)] 'delete-backward-char)
  (local-set-key [tab]                 'completion-at-point)
  (local-set-key [(control tab)]       'scroll-other-window)

  (setq comint-input-ignoredups   t)
  (setq comint-input-autoexpand   t)
  (setq comint-scroll-to-bottom-on-input `this)
  (setq my-comint-mode t)
  (make-local-variable 'kill-buffer-hook)
  (add-hook 'kill-buffer-hook 'comint-write-input-ring)
  (turn-off-auto-fill)
  )

(add-hook 'comint-mode-hook 'my-comint-mode-hook t)

(require 'term)

(defun my-term-scroll-to-bottom-on-input ()
  "Kind of copied `comint-preinput-scroll-to-bottom' solution for term-shell-mode"
  (if (memq this-command '(self-insert-command))
      (my-term-move-to-command-line 0)))

(defun my-term-highlight-given-prompt (point-at-term-bol)
  "Highligts the prompt which ends at given point"
  (interactive)
  (add-text-properties (point-at-bol) point-at-term-bol
                       '(rear-nonsticky t font-lock-face '(foreground-color . "cyan"))))

(defun my-term-highlight-prompt (str)
  "Highligts the prompt(s) if anyone exists in given process output."
  (interactive)
  (if (and my-term-shell-mode (string-match term-prompt-regexp str))
      ;;(my-term-highlight-all-prompts)))
      (save-excursion
          (goto-char (point-max))
          (re-search-backward term-prompt-regexp)
          ;;(message (concat "got: " str))
          (my-term-highlight-given-prompt (term-bol nil))
          (goto-char (point-max))
          )))

(defun my-term-highlight-all-prompts ()
  "Highlights all prompts in current buffer."
  (interactive)
  (if my-term-shell-mode
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward term-prompt-regexp nil t)
          (my-term-highlight-given-prompt (point)))
        (goto-char (point-max))
        )))

(defadvice term-emulate-terminal
  (after my-term-highlight-prompt (PROC STR))
  "Highligt prompt - see `my-term-highlight-prompt'."
  (my-term-highlight-prompt STR))
(ad-activate 'term-emulate-terminal)

(defun my-term-shell-mode-hook ()
  (local-set-key [home]                'term-bol)
  (local-set-key "\C-a"                'term-bol)
  (local-set-key [up]                  'term-previous-matching-input-from-input)
  (local-set-key [(control up)]        'previous-line)
  (local-set-key [down]                'term-next-matching-input-from-input)
  (local-set-key [(control down)]      'next-line)
  (local-set-key [left]                'my-term-backward-char)
  (local-set-key [backspace]           'my-term-delete-backward-char)
  (local-set-key [(control backspace)] 'delete-backward-char)
  (local-set-key [tab]                 'term-dynamic-complete)
  (local-set-key [(control tab)]       'scroll-other-window)

  (setq term-input-ignoredups   t)
  (setq term-input-autoexpand   t)
  ;; No "on-input"
  ;;(setq term-scroll-to-bottom-on-input `this)
  (add-hook 'pre-command-hook 'my-term-scroll-to-bottom-on-input t t)
  (setq my-term-shell-mode t)
  (make-local-variable 'kill-buffer-hook)
  (add-hook 'kill-buffer-hook 'term-write-input-ring)
  (turn-off-auto-fill)
  )

;;(add-hook 'term-mode-hook 'my-term-shell-mode-hook t)

(defun my-ring-ref (ring index)
  (and (> (ring-length ring) 0) (ring-ref ring index)))

(defun my-simple-send (proc string)
  "As `term-simple-send'/`comint-simple-send' but skips the newline."
  (if my-term-shell-mode
      (term-send-string proc string)
    (comint-send-string proc string)))

(defun my-strip-completion-tab ()
  "Removes trailing tabs when no further completion is possible."
  (if (re-search-backward  "\\(	+$\\)" (point-at-bol) t)
      (replace-match "")))

(defun my-send-tab ()
  "Sends a tab to the shell to get completions on input"
  (interactive)
  (let* ((org-term-fun term-input-sender)
         (org-comint-fun comint-input-sender)
         (used-ring (if my-term-shell-mode term-input-ring comint-input-ring))
         (last-history (my-ring-ref used-ring 0)))
    (condition-case nil
        (progn
          (setq-local term-input-sender (function my-simple-send))
          (setq-local comint-input-sender (function my-simple-send))
          (insert "	")
          (my-send-input)
          (run-at-time 0.1 nil 'my-strip-completion-tab)
          (if (not (eq last-history (my-ring-ref used-ring 0)))
              (ring-remove used-ring 0))
          )
      (quit
       nil)
      (error
       nil))
    (setq-local term-input-sender org-term-fun)
    (setq-local comint-input-sender org-comint-fun)
    t
    ))

(defun my-send-input ()
  (if my-term-shell-mode
      (term-send-input)
    (comint-send-input)))

(defun my-send-return ()
  (interactive)
  (let* ((cmd (if my-term-shell-mode
                  (term-get-old-input-default)
                (comint-get-old-input-default)))
         (used-ring (if my-term-shell-mode term-input-ring comint-input-ring))
         (last-history (my-ring-ref used-ring 0))
         )
    (end-of-line)
    (my-send-input)
    ;; If beginning of cmd is completed by shell, only the typed arguments
    ;; will be stored in the history. Replace this entry with the complete
    ;; command in that case.
    (if (and (not (string-equal (my-ring-ref used-ring 0) cmd))
             (not (string-equal (my-ring-ref used-ring 0) last-history)))
        (ring-remove used-ring 0))
    ;; Insert cmd as last entry in history in case it been filtered out or
    ;; removed
    (if (not (string-equal (my-ring-ref used-ring 0) cmd))
        (ring-insert used-ring cmd))))

(defvar activate-mark-hook nil "This hook is run when a mark is set")
(defvar deactivate-mark-hook nil "This hook is run when a mark is removed")

(defun my-activate-mark-hook ()
"Resets \"movement\" keys to original when selecting text in `comint-mode'"
  (interactive)
  (cond ( (or my-comint-mode my-term-shell-mode)
          (local-set-key [up]   'previous-line)
          (local-set-key [down] 'next-line)
          (local-set-key [left] 'backward-char))))
(add-hook 'activate-mark-hook 'my-activate-mark-hook t)


(defun my-deactivate-mark-hook ()
"Resets movement-keys to `my-comint-mode-hook' when de-selecting text in
`comint-mode'"
  (interactive)
  (cond ( my-comint-mode
          (local-set-key [up]   'comint-previous-matching-input-from-input)
          (local-set-key [down] 'comint-next-matching-input-from-input)
          (local-set-key [left] 'my-comint-backward-char))

        ( my-term-shell-mode
          (local-set-key [up]   'term-previous-matching-input-from-input)
          (local-set-key [down] 'term-next-matching-input-from-input)
          (local-set-key [left] 'my-term-backward-char))
        ))
(add-hook 'deactivate-mark-hook 'my-deactivate-mark-hook t)

;; Python
(require 'python nil t)
(defun my-python-shell-mode-hook ()
  "My python-shell-mode-hook"
  (interactive)
  (local-set-key [(control tab)] 'dabbrev-expand)

  (set-process-query-on-exit-flag (get-buffer-process (buffer-name)) nil)
  (setq-local comint-input-ring-file-name "~/.python_history")
  (comint-read-input-ring))

(add-hook 'inferior-python-mode-hook 'my-python-shell-mode-hook t)

(defun my-python-mode-hook ()
  (interactive)
  (setq indent-tabs-mode t)
  (setq python-indent-offset 4)
  (setq tab-width python-indent-offset)
  (let ((buffer-content (buffer-string)))
    (if (and (> (length buffer-content) 0)
             (not (string-match "^	" buffer-content)))
        (setq indent-tabs-mode nil)))
  (cond ( (require 'whitespace nil t)
          (setq whitespace-style (list `face `indentation `space-before-tab `space-after-tab `empty))
          (whitespace-mode t)))
  (local-set-key "\C-c\C-c" 'comment-region)
  (local-set-key [return]   'newline-and-indent)
  (if (is-xemacs)
      (local-set-key [(shift return)]  'newline)
    (local-set-key [S-return]  'newline))
  )

(add-hook 'python-mode-hook 'my-python-mode-hook t)

;; Turn on auto-fill in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Don't ask to kill lynx-process
(add-hook 'term-exec-hook
          (lambda () (set-process-query-on-exit-flag
                      (get-buffer-process (current-buffer))
                      nil)))

;; Strip things in grep results
(add-hook 'grep-mode-hook
          (lambda () (local-set-key "k" 'kill-all-matching-lines)))

(defun my-js-mode-hook ()
  (local-unset-key "\e\C-x")
  (global-set-key "\e\C-x\C-d" 'my-vc-ediff-other-current-buffer)
  (local-set-key [return]   'newline-and-indent)
  (local-set-key [S-return]  'newline)
  )

(add-hook 'js-mode-hook 'my-js-mode-hook t)

(require 'hideshow)
(when (require 'json-mode nil t)
  (setq hs-special-modes-alist (append hs-special-modes-alist '((json-mode "[{[]" "[}\\]]" "/[*/]" nil))))
  (defun my-json-mode ()
    (interactive)
    (hs-minor-mode)
    ;;(json-mode-beautify)
    (local-set-key [tab] 'hs-toggle-hiding)
    )

  (add-hook 'json-mode-hook 'my-json-mode t))

;; Windows stuff
(defun my-strip-strlm ()
  (goto-char (point-min))
  (while (re-search-forward "\r+$" nil t) (replace-match "" t t)))

(defun dos-shell-command ()
  (interactive)
  (call-interactively 'shell-command)
  (let ((output (get-buffer "*Shell Command Output*")))
    (if (not output)
      t
      (set-buffer output)
      (goto-char (point-min))
      (while (re-search-forward "\r+$" nil t) (replace-match "" t t))
      (goto-char (point-min))
      (display-buffer output))))

(require 'shell)
(require 'compile)
(cond ( (is-windows)

        ;; indent-region (Control+Alt doesn't
        ;; seem to work in Windows)
        (global-set-key "\334" 'indent-region)

        ;; Make shell work in Windows
        (setq shell-file-name "cmdproxy.exe")
        (setq explicit-shell-file-name "cmdproxy.exe")

        ;; Make grep work in Windows
        (setq grep-command "findstr /n /C:")

        ;; Recursive grep in Windows
        (setq grep-find-command "findstr /n /s /C:")

        ;; Make diff work in Windows
        (setq diff-command "fc /n /t ")
        (setq diff-switches "")

        ;; Browser
        (setq-default browse-url-browser-function
                      'browse-url-default-windows-browser)

;;        ;; Make ediff work in Windows
;;        (setq ediff-diff-program "fc")
;;        (setq ediff-diff-options "/n /t")
;;        (setq ediff-diff3-program "fc")
;;        (setq ediff-diff-ok-lines-regexp
;;              "^\\([0-9,]+[acd][0-9,]+?$\\|[ ]*[0-9]+:\\|.*Comparing files.*\\|[<>] \\|---\\|\\*\\*\\*\\*\\*.*\\|.*Warning *:\\|.*No +newline\\|.*missing +newline\\|^?$\\)")
;;        (setq ediff-match-diff-line
;;              "^[ ]+\\([0-9]+\\)\\(:\\)\\(.*$\\)

        ;; Set directory separator to '\' in Windows
        (setq directory-sep-char 92)
        (setq comint-completion-addsuffix '("\\" . ""))

        ;; Dos stuff...
        (global-set-key "\e!" 'dos-shell-command)

        ;; Set up Printer
        (setq-default ps-lpr-command "")
        (setq-default printer-name "SELN01077204BP")
        ;;(setq-default printer-name "//ESELNMW001/LN81LJ_PS")
        (setq-default ps-printer-name printer-name)

        ;; Support for shortcuts
        ;;(require 'w32-symlinks)
        ;;(setq-default w32-symlinks-handle-shortcuts t)
        ;; Clearcase needs this
        (require 'executable)
        )
)

;; My own functions
;;;;;;;;;;;;;;;;;;;
(defun my-compile ()
  "Same as 'compile but switches window, and tails the buffer."
  (interactive)
  (let ((compilation-buffer (buffer-name (call-interactively 'compile))))
    (if (not (string-equal compilation-buffer (buffer-name)))
        (switch-to-buffer-other-window compilation-buffer))
    (goto-char (point-max))))

(defun my-kill-whole-line ()
  "Kill entire line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (kill-line nil)))

(defun kill-all-matching-lines (what)
  "Kill all lines in buffer matching input."
  (interactive (list (read-shell-command "Kill what: ")))
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward (concat "^.*" what ".*\n") nil t)
      (replace-match ""))))

(defun my-string-match (regexp data num)
  (interactive)
  (string-match regexp data)
  (match-string num data))

;; Host specific section
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Clearcase/Git
(load ".emacs_vc")

;; Erlang support
(defun get-erlang-bin-dir ()
  (interactive)
  (let* ((erl-path (shell-command-to-string "echo -n `which \\erlc`"))
         (erl-alias (shell-command-to-string "echo -n `which erlc`"))
         (erl-bin-dir (if (string-match "Command not found" erl-path)
                          ;; Path not set - try alias
                          (if (string-match "Command not found" erl-alias)
                              ;; We're smoked
                              ""
                            (file-truename erl-alias))
                        ;; Path set
                        (file-truename erl-path)))
         (erl-root-dir (if (string-match "[^/]*\\(.+\\)/bin/erlc" erl-bin-dir)
                           (match-string 1 erl-bin-dir)
                         ""))
         (erl-parent-dir (if (string-match "[^/]*\\(.+\\)/[^/]+" erl-root-dir)
                           (match-string 1 erl-root-dir)
                           "")))

    (if (and (not (eq erl-bin-dir "")) erl-root-dir (not (file-readable-p (concat erl-root-dir "/man"))))
        (progn
          (setq erl-root-dir (shell-command-to-string (concat "find " erl-parent-dir " -maxdepth 2 -type d -name  \"man\" -print0 -quit | xargs --null echo -n")))
          (if (string-match "[^/]*\\(.+\\)/man" erl-root-dir)
              (setq erl-bin-dir (concat (match-string 1 erl-root-dir) "/bin/erl"))
          )
        )
      )
    (if (not (string-match erl-root-dir (or (getenv "MANPATH") "")))
        (setenv "MANPATH" (concat erl-root-dir "/man:" (getenv "MANPATH"))))
    ;;(replace-regexp-in-string "\n" "" erl-bin-dir)
    erl-bin-dir
    )
)

(defun get-erlang-emacs-dir (&optional root)
  (if (not root)
      (if erlang-root-dir (get-erlang-emacs-dir erlang-root-dir))

    (if (> emacs-major-version 27)
        (setq root (ensure-otp-24 root)))

    (if (file-readable-p (concat root "/lib/tools-0/emacs"))
        (concat root "/lib/tools-0/emacs")
      (shell-command-to-string (concat "find " root " -type d -name emacs -print0 | xargs --null echo -n")))))

(defun get-otp-version (dir)
  (my-string-match ".*\\(otp/\\|otp_\\)\\([0-9]+\\)" dir 2))

(defun ensure-otp-24 (root)
  (let ((otp-version (get-otp-version root))
        (otp-root (replace-regexp-in-string "/\\(otp_\\)?[0-9.]+$" "" root)))
    (if (string-greaterp otp-version "23")
        root
      (shell-command-to-string (concat "echo -n `find " otp-root " -maxdepth 1 -xtype d -name '24*' |sort -r | head -1`")))
    ))

(cond ( (is-unix)
        (let* ((erl-bin-dir (get-erlang-bin-dir)))
          (cond ((string-match "[^/]*\\(.+\\)/bin/erl" erl-bin-dir)
                 (setq erlang-root-dir (match-string 1 erl-bin-dir))
                 (setq exec-path (cons (concat erlang-root-dir "/bin") exec-path))
                 (setq load-path
                       (append (list (get-erlang-emacs-dir erlang-root-dir))
                               load-path)))))

        )

      ;;( (is-windows)
      ;;  (setq load-path (append (list "~/emacs") load-path))
      ;;)
)


; Start erlang
(if
    (if (and (< emacs-major-version 21)
             ;; OTP no longer supports emacs < 21.
             (load "erlang-start-old" 1))
        t
      (load "erlang-start" 1))
    (progn

      (add-hook    'erlang-shell-mode-hook 'my-erlang-shell-mode-hook t)
      (add-hook    'erlang-mode-hook       'my-erlang-mode-hook t)

      (autoload 'my-erlang-shell-mode-hook ".emacs_erlang")
      (autoload 'my-erlang-mode-hook       ".emacs_erlang")
      (autoload 'bt-erl                    ".emacs_erlang" nil 1)
      (autoload 'tecsas                    ".emacs_erlang" nil 1)
      (autoload 'gtt                       ".emacs_erlang" nil 1)
      (autoload 'gsh                       ".emacs_erlang" nil 1)

      (and (is-emacs)
           (font-lock-add-keywords
            'erlang-mode
            '(("\\<\\(true\\|false\\|ok\\|fault\\|void\\|undefined\\|binary\\|bitstring\\|bytes\\)\\>"
               . font-lock-keyword-face)
              ("\\<\\(is_\\(list\\|atom\\|tuple\\|binary\\|bitstring\\)\\) *("
               . font-lock-keyword-face))))))

;; Prog-styles
(add-hook 'c-mode-hook   'my-c-mode-hook t)
(add-hook 'c++-mode-hook 'my-c-mode-hook t)
(add-hook 'idl-mode-hook 'my-idl-mode-hook t)

(autoload 'my-c-mode-hook   ".emacs_cstyle")
(autoload 'my-idl-mode-hook ".emacs_cstyle")

(autoload 'diaspec-mode     ".emacs_erlang")

(setq-default compile-command   "gmake all")
;(setq-default grep-find-command (format "find . -name \"\*.\*\" --exec %s {} /dev/null \\;" grep-command))

(setq compile-history (list "gmake all" "setenv JERRY_DIR $GSN_WS_ROOT/sgsn_mme/cmtools/jerry;gmake -f config/" "bt_run ." "erlc -W" "g++ -g -ansi -pedantic -lsocket -lnsl -lpthread -D_REENTRANT " "CC -g -mt -lsocket -lnsl -lpthread " "make all" "check_coverage.sh" "findMFAs"))
;; Because auto wpp does it the "wrong way"...
(setq-default compilation-search-path (list nil "solaris" "vxworks_ppcall"))

;; Auto Modes
(setq auto-mode-alist
      (append '(("\\..*cshrc.*"   . sh-mode)
                ("\\..*login.*"   . sh-mode)
                ("\\..*profile.*" . sh-mode)
                ("\\..*emacs.*"   . emacs-lisp-mode)
                ("\\.mak"         . makefile-mode)
                ("\\.make"        . makefile-mode)
                ("\\.mk\\>"       . makefile-mode)
                ("\\.csf\\>"      . makefile-mode)
                ("\\.ast\\>"      . makefile-mode)
                ("\\.blu\\>"      . makefile-mode)
                ("\\.def\\>"      . makefile-mode)
                ("\\.cc\\>"       . c++-mode)
                ("\\.hh\\>"       . c++-mode)
                ("\\.c\\>"        . c-mode)
                ("\\.h\\>"        . c-mode)
                ("\\.idl\\>"      . idl-mode)
                ("\\.erl\\>"      . erlang-mode)
                ("\\.hrl\\>"      . erlang-mode)
                ("\\.asn\\>"      . snmp-mode)
                ("\\.diaSpec\\>"  . diaspec-mode)
                ("\\.\\(dialyzer\\|plt\\).log\\>" . compilation-mode)
                )
            auto-mode-alist
            ))

;; My own functions
;;;;;;;;;;;;;;;;;;;

;; my-find-file-at-point
(require 'ffap)
(defun my-find-file-at-point ()
"Interprets word at position as a filename and opens the file"
  (interactive)
  (if (ffap-file-at-point)
      (let* ((name            (substitute-in-file-name (ffap-file-at-point)))
             (text            (substitute-in-file-name (ffap-string-at-point)))
             (split-name      (split-string text "@@"))
             (name-no-version (car split-name))
             (version         (if (> (length split-name) 1) (nth 1 split-name)))
             (name            (if (and version (file-directory-p name))
                                  text
                                name)))
        (if (file-readable-p name)
            (find-file-other-window name)
          (if (and version (file-readable-p name-no-version))
              (magit-find-file-other-window version name-no-version)
            (message (concat name " not readable")))))
    (message (concat (ffap-string-at-point) " not found")))
  )

(require 'compile)
(defvar my-find-mode-map nil
  "Keymap used in my-find-mode.")
;; Define "my-find-mode"
(defun my-find-mode ()
  (interactive)
  (setq major-mode 'my-find-mode)
  (setq mode-name "find")
  (setq my-find-mode-map (make-sparse-keymap))
  (set-keymap-parent my-find-mode-map compilation-mode-map)
  (use-local-map my-find-mode-map)
  (local-set-key [return]  'my-find-file-at-point)
  (local-set-key [mouse-2] 'my-find-file-at-point))


;; Define "find command" to use
(if (is-windows)
    (defvar find-default "dir /b /s ")
  (defvar find-default "find ")
)
;; Define "find history" to use
(defvar find-history nil)

;; Find routine.
(defun my-find ()
    "Run find, with user-specified args, and collect output in a buffer."
    (interactive)
    (my-compilation-start (read-shell-command "Run find (like this): "
                                              find-default
                                              'find-history)
                          "No more files found"
                          (lambda (n) "*find*"))
    (if (not (string-equal "*find*" (buffer-name)))
        (switch-to-buffer-other-window "*find*"))
    (my-find-mode)
    (goto-char (point-max))
)

(global-set-key "\C-f"     'my-find)

;; Stop process
(defun my-stop-process ()
  "Stop current process."
  (interactive)
  (let (proc (get-buffer-process (current-buffer)))
    (interrupt-process proc)
    (delete-process proc)
    )
  )

(defun my-get-buffer-file-name ()
  (interactive)
  (if buffer-file-name
      buffer-file-name
    dired-directory))

(defun my-fix-long-name (name)
  (interactive)
  (if (>= 80 (length name))
      name
    ;; Name longer th 80 found
    (setq name (substring (concat (reverse (string-to-list name))) 0 77))
    (setq name (concat (reverse (string-to-list name))))
    (save-match-data
      (if (eq (string-match "\\([^/]+\\)/.+" name) 0)
          (setq name (replace-match "" nil nil name 1)))
      )
    (concat "..." name)))


(defun my-get-frame-title ()
  (interactive)
  (let ((my-buffer-name (my-get-buffer-file-name)))
    (if my-buffer-name
        (my-fix-long-name my-buffer-name)
      (buffer-name))))

(defun revert-buffer-if-needed ()
  (my-git-fix-messed-up-modtime)
  ;; Check if buffer needs revert,
  (if (not (verify-visited-file-modtime (current-buffer)))
      (revert-buffer)))

;; Load emacs or Xemacs specific definitions
(if (is-xemacs)
    (load ".xemacs")
  (load ".emacs_emacs"))

(sgsn-tags)

(defun get-line-length ()
  "Get length of current line"
  (interactive)
  (string-width (buffer-substring (line-beginning-position) (line-end-position))))

(defun goto-long-line ()
  "Goto next line longer than 'fill-column characters"
  (interactive)
  (forward-line 1)
  (end-of-line)
  (while (and (not (> (get-line-length) fill-column)) (not (eobp)))
    (forward-line 1)
    (end-of-line)))

(defun dos-file ()
  "Interpret the current buffer as a dos file"
  (interactive)
  (let ((linenum (count-lines 1 (point))))
    (set-buffer-file-coding-system 'dos)
    (revert-buffer nil t)
    (goto-char (point-min))
    (if (> linenum 0)
        (forward-line (1- linenum)))))

(defun make-wiki-entry ()
  (interactive)
  (beginning-of-line)
  (insert "|-\n")
  (replace-regexp-once "\\(.*$\\)" "| <span style=\"color: red;\">\\1</span>")
  (forward-line)
  (replace-regexp-once "\\(.*/\\([0-9]+\\)$\\)" "| [\\1 \\2]")
  (insert "\n| \n| \n| Team \n| \n| \n| \n"))

(defun read-line ()
  (replace-regexp-in-string "\n" "" (thing-at-point 'line t)))

(defun replace-regexp-once (REGEXP TO-STRING)
  (re-search-forward REGEXP)
  (replace-match TO-STRING))
  ;;(set-mark-command (beginning-of-line))
  ;;(end-of-line)
  ;;(replace-regexp REGEXP TO-STRING nil (region-beginning) (region-end)))

; (defvar menu-bar-functions-menu (make-sparse-keymap "Functions"))
; (define-key global-map [menu-bar functions] (cons "Functions" menu-bar-functions-menu))

; (define-key menu-bar-functions-menu [make]
;    '('imenu--index-alist . ))
;   ' build))

;(define-key overriding-terminal-local-map [backspace] 'my-delete-backward)

(defun make-process-buffer-name (name)
  (concat "*" name "*"))

;;; End .emacs
(if (featurep 'benchmark-init-loaddefs)
    (benchmark-init/deactivate))
