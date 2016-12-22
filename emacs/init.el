;;
;;
;; RPINDER INIT.EL FILE
;;   http://github.com/rpinder
;;
;;

;; last edited: 22/12/2016

;; I know very little elisp

;; Crediting
;;   I will try and credit all the code I paste into this file however sometimes
;;   I will forget or there will be some things I added in before I started
;;   crediting so just tell me if I forget something

;; TODO
;; + setup emacs for c/c++
;;   - semantic autocomplete
;;   - easily switch between header and source file
;;   - fuzzy finder (?)
;; + make my .emacs more organised
;;   - documentation
;;     - file size doesn't matter, lots of comments 
;;   - re-order parts
;;   - use multiple files
;;   - move to init.el
;;   - use-package (?)
;;   - org mode integration (?)
;; + smooth scrolling

;-------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          UI CONFIG
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove useless (to me) clutter
(menu-bar-mode -1)
(when (display-graphic-p) ;; these elements don't exist in the terminal emacs
  (tool-bar-mode -1)      ;; so turning them off isn't needed
  (scroll-bar-mode -1))

(global-linum-mode 1)     ;; enables line numbers in fringe
(global-hl-line-mode 1)   ;; toggles line highlighting in all buffers

(setq column-number-mode t) ;; puts column number in the mode line

;; puts a space between number line and window border
(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat " %" (number-to-string w) "d ")))
    ad-do-it))

(setq inhibit-startup-screen t) ;; disables emacs start screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;           CUSTOM FUNCTIONS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; opens emacs configuration file and puts buffer into the correct mode
(defun open-dotfile () (interactive)
       (find-file "~/dotfiles/emacs/init.el")
       (emacs-lisp-mode))

;; opens zsh configuration file and puts buffer into the correct mode
(defun open-zsh () (interactive)
       (find-file "~/dotfiles/.zshrc")
       (shell-script-mode))

(defun load-emacs () (interactive)
       (load-file "~/.emacs"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          MODE HOOKS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'eshell-mode-hook (lambda () (linum-mode -1)))
(add-hook 'eshell-mode-hook (lambda () (set-window-fringes nil 0 0)))
(add-hook 'eshell-mode-hook (lambda () (global-hl-line-mode -1)))
(add-hook 'ruby-mode-hook (lambda () (global-rbenv-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          CUSTOM KEYBINDS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x o") 'switch-window)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(defvar org-log-done t)

(setq-default indent-tabs-mode nil)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-default nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          AUTOMATIC PACKAGE INSTALLATION
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This code is from the "Automatically installing Packages" section of the
;; "From Vim to Emacs in Fourteen Days article by Arron Bieber posted on May
;; 24th 2015

;; http://blog.aaronbieber.com/2015/05/24/from-vim-to-emacs-in-fourteen-days.html

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it's not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive descriptions
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(package-initialize)

(ensure-package-installed 'evil
                          'evil-surround
                          'ido-vertical-mode
                          'org-bullets
                          'neotree
                          'smex
                          'ido-ubiquitous
                          'flycheck
                          'quickrun
                          'magit
                          'switch-window
                          'rbenv
                          'spacegray-theme
                          'hlinum
                          'auto-complete
                          'auto-complete-c-headers
                          'pdf-tools
                          'key-chord
                          'winum
                          'which-key
                          'git-gutter
                          'github-browse-file
                          )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          PACKAGE CONFIG  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-theme 'spacegray t)

(ac-config-default)

(pdf-tools-install)

(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(require 'evil-leader)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
 "0" 'winum-select-window-0-or-10
 "1" 'winum-select-window-1
 "2" 'winum-select-window-2
 "3" 'winum-select-window-3
 "4" 'winum-select-window-4
 "5" 'winum-select-window-5
 "6" 'winum-select-window-6
 "7" 'winum-select-window-7
 "8" 'winum-select-window-8
 "9" 'winum-select-window-9)

(global-evil-leader-mode)
(require 'evil)
(evil-mode t)
; I should just use a modeline plugin
(setq evil-mode-line-format '(before . mode-line-front-space))
(setq evil-normal-state-tag   (propertize " NORMAL  " 'face '((:background "#343d46")))
      evil-emacs-state-tag    (propertize " EMACS   " 'face '((:background "#C189EB")))
      evil-insert-state-tag   (propertize " INSERT  " 'face '((:background "#27AE60")))
      evil-motion-state-tag   (propertize " MOTION  " 'face '((:background "#89EBCA")))
      evil-visual-state-tag   (propertize " VISUAL  " 'face '((:background "#DCA432")))
      evil-replace-state-tag  (propertize " REPLACE " 'face '((:background "#bf616a")))
      evil-operator-state-tag (propertize " NORMAL  " 'face '((:background "#343d46"))))


(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require 'neotree)
(setq neo-theme 'ascii)
(global-set-key "\C-cn" 'neotree-toggle)
(setq neo-smart-open t)
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))


(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(require 'tramp)

(setq package-enable-at-startup nil)

(require 'quickrun)

(require 'rbenv)
;; Setting rbenv path
(setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
(setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))
(setq rbenv-modeline-function 'rbenv--modeline-plain)

(require 'hlinum)
(hlinum-activate)

(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)

(require 'winum)
(setq winum-mode-line-position 14)
(winum-mode)

(require 'which-key)
(which-key-mode)

(require 'git-gutter)
(global-git-gutter-mode t)
(git-gutter:linum-setup)
(global-set-key (kbd "C-c C-k") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-c C-j") 'git-gutter:next-hunk)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Meslo LG M DZ for Powerline" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal))))
 '(linum-highlight-face ((t (:background "#343d46" :foreground "yellow")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(custom-safe-themes
   (quote
    ("d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "1b27e3b3fce73b72725f3f7f040fd03081b576b1ce8bbdfcb0212920aec190ad" "64ca5a1381fa96cb86fd6c6b4d75b66dc9c4e0fc1288ee7d914ab8d2638e23a9" "721bb3cb432bb6be7c58be27d583814e9c56806c06b4077797074b009f322509" "946e871c780b159c4bb9f580537e5d2f7dba1411143194447604ecbaf01bd90c" default)))
 '(fci-rule-color "#343d46")
 '(git-gutter:update-interval 1)
 '(package-selected-packages
   (quote
    (github-browse-file git-gutter which-key winum key-chord pdf-tools hlinum switch-window smex rbenv quickrun org-bullets neotree magit ido-vertical-mode ido-ubiquitous flycheck evil-surround base16-theme)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#bf616a")
     (40 . "#DCA432")
     (60 . "#ebcb8b")
     (80 . "#B4EB89")
     (100 . "#89EBCA")
     (120 . "#89AAEB")
     (140 . "#C189EB")
     (160 . "#bf616a")
     (180 . "#DCA432")
     (200 . "#ebcb8b")
     (220 . "#B4EB89")
     (240 . "#89EBCA")
     (260 . "#89AAEB")
     (280 . "#C189EB")
     (300 . "#bf616a")
     (320 . "#DCA432")
     (340 . "#ebcb8b")
     (360 . "#B4EB89"))))
 '(vc-annotate-very-old-color nil))

;; This makes the inactive modeline darker than the active modeline. This
;; probably isn't the best solution but this apparently needs to be ran after the
;; section - probably isn't true
(set-face-foreground 'modeline-inactive "#777777")
(set-face-background 'modeline-inactive "#181b22")