;; Turn the menu bar on again
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse    
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Do not open files in a new frame
(setq ns-pop-up-frames nil)

(setq ns-alternate-modifier 'none)
(setq ns-command-modifier 'meta)

;;use delete-selection-mode
(delete-selection-mode 1)

;;makes Emacs automatically revert the current buffer every five seconds
(global-auto-revert-mode 1)

;;; Auto indent on paste
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
                (member major-mode '(emacs-lisp-mode lisp-mode
                                                     clojure-mode    scheme-mode
                                                     haskell-mode    ruby-mode
                                                     rspec-mode      python-mode
                                                     c-mode          c++-mode
                                                     objc-mode       latex-mode
                                                     plain-tex-mode  cuda-mode
                                                     html-mode       java-mode
                                                     ))
                (let ((mark-even-if-inactive transient-mark-mode))
                  (indent-region (region-beginning) (region-end) nil))))))

;; disable annoying bell behaviour
(defun my-bell-function ()
  (unless (memq this-command
                '(isearch-abort abort-recursive-edit exit-minibuffer
                                keyboard-quit mwheel-scroll down up next-line previous-line
                                backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

(global-set-key (kbd "<kp-delete>") 'delete-char)
(define-key local-function-key-map (kbd "<kp-delete>") (kbd "C-d"))

(when window-system
   (setq frame-title-format t)
   (tooltip-mode t))

;; Replace Espresso with js-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

;;; Set new lines to be indented automatically
(define-key global-map (kbd "RET") 'newline-and-indent)

;; RVM mode
(add-to-list 'load-path "~/.emacs.d/rvm.el/")
(require 'rvm)
(rvm-use-default) ;; use rvm’s default ruby for the current Emacs session

(add-to-list 'load-path "~/.emacs.d/darkroom-mode/")
(require 'darkroom-mode)

;; Custom org install
(require 'org-install)

(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  )
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; Preview Markdown with Marked.app
;; http://support.markedapp.com/kb/how-to-tips-and-tricks/marked-bonus-pack-scripts-commands-and-bundles
(defun markdown-preview-file ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command 
   (format "open -a /Applications/Marked.app %s" 
           (shell-quote-argument (buffer-file-name))))
  )
(global-set-key "\C-cm" 'markdown-preview-file)
