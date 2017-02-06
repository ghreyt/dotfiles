;;;;
;;;; emacs configuration file
;;;;
;;;; urls to read:
;;;;   - EmacsWiki: https://www.emacswiki.org/
;;;;   - comment: https://www.gnu.org/software/emacs/manual/html_node/elisp/Comment-Tips.html
;;;;
;;;; TODO:
;;;;   -  read more http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/


;;;; (really) basic keys for emacs
;;;; -----------------------------
;;;;
;;;; C-b/b/p/n : move
;;;; C-g : cancel current action
;;;; M-x : execute function
;;;; F10 - open menu bar, menu-bar-open
;;;; M-` : open menu, tmm-menubar
;;;; C-x o : move to other buffer
;;;; C-x 0 : close the current buffer
;;;; C-x 1 : close other divided buffers
;;;; C-x 2 : duplicate buffer vertically 
;;;; C-x 3 : duplicate buffer horizontally


;;; repository
;;; ----------
;;; use melpa stable
;;; https://www.emacswiki.org/emacs/ELPA_
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ;("marmalade" . "https://marmalade-repo.org/packages/")
                         ))
(package-initialize)


;;; install packages
;;; ----------------
;;; install packages when Emacs is launched for the first time

;; get pakcage list if have not been initialized
(unless package-archive-contents
  (package-refresh-contents))
;(or (file-exists-p package-user-dir)
;    (package-refresh-contents))

;; define function to check and install packages
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
(ensure-package-installed 'evil ; vim emulation
                          'tabbar ; show tab on top of the editor
                          'helm ; better search UI
                          'evil-magit ; git
                          'git-gutter ; show git status for each line in file
                          'powerline-evil ; beautify bottom status bar
                          'flycheck ; flycheck to check syntax on the fly
                          'flycheck-tip
                          'markdown-mode ; markdown
                          'edts ; erlang
                          'go-mode ; go
                          'go-autocomplete
                          'go-eldoc
                          'elpy ; python
                          'ensime ; scala
                          'deft ; write document
                          'popup-imenu
                          'dired+
                          'indent-guide ; show indentation line
						  )


;;; benchmark-init
;;; --------------
;;; uncomment this to benchmark emacs startup
;(add-to-list 'load-path "~/.emacs.d/elpa/benchmark-init-20150905.238/")
;(require 'benchmark-init)
;(benchmark-init/activate)


;;; common settings
;;; ---------------
(setq tab-width 4)
(setq inhibit-startup-screen t)         ; disable gnu emacs greeting buffer
(setq make-backup-files nil)            ; don't make backup files
(setq auto-save-default nil)            ; disable auto-save not to make files starting with '#'
(setq backup-directory-alist
      `(("." . "~/.emacs_backups")))    ; set directory to put backup files
                                        ; emacs makes backup files even though set nil to 'make-backup-files' above
(tool-bar-mode -1)                      ; disable toolbar
(menu-bar-mode 0)                       ; disable menubar
(setq linum-format "%4d ")              ; show line number and delimiter
(setq-default indent-tabs-mode nil)     ; do not use tab to indent
(load-theme 'tango-dark)                ; theme

;; to use zsh in emcas ansi-term without any problem of colors
;; http://stackoverflow.com/questions/8918910/weird-character-zsh-in-emacs-terminal
(setq system-uses-terminfo nil)
(setq scroll-step 1
      conservatively 100000)

;; navigate buffers f3/f4 in the order of access
(global-set-key (kbd "<f3>") 'previous-buffer)
(global-set-key (kbd "<f4>") 'next-buffer)

;; set new key to kill a buffer
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-x K") 'kill-buffer)



;;; evil
;;; ----
;;; * Vim emulation in Emacs
;;; * https://www.emacswiki.org/emacs/Evil
(require 'evil)
;; unmap some keys which I do not want and use default keys instead
(define-key evil-normal-state-map (kbd "M-.") nil)
(define-key evil-normal-state-map (kbd "M-,") nil)
(define-key evil-normal-state-map (kbd "q") 'quit-window)
(evil-mode 1)
(modify-syntax-entry ?_ "w")   ; consider '_' as part of word like vim
                               ; TODO make this apply to every mode
(setq evil-flash-delay 86400)  ; keep hightlighted word permanently
;; Set the initial evil state that certain major modes will be in.
;(evil-set-initial-state 'magit-log-edit-mode 'emacs)
;(evil-set-initial-state 'nav-mode 'emacs)
;(evil-set-initial-state 'grep-mode 'emacs)
;(evil-set-initial-state 'ibuffer-mode 'normal)
(add-hook 'grep-mode-hook 'my-evil-grep-hook)
(defun my-evil-grep-hook()
  "set h to <left>"
  (local-set-key (kbd "h") (kbd "<left>")))
(add-to-list 'evil-emacs-state-modes 'term-mode) ; start deft in evil-insert-mode


;;; powerline-evil
;;; --------------
;;; * evil support for powerline
;;; * https://github.com/raugturi/powerline-evil
(require 'powerline-evil)
;(powerline-default-theme)
;(powerline-evil-center-color-theme)
;(powerline-evil-vim-theme)
(powerline-evil-vim-color-theme)


;;; tabbar
;;; ------
;;; * show tabs on top of window
;;; * https://github.com/dholm/tabbar
;; navigate groups
(global-set-key (kbd "<f6>") 'tabbar-forward-group)
(global-set-key (kbd "<f7>") 'tabbar-backward-group)
;; navigate tabs in a group
(global-set-key (kbd "<f12>") 'tabbar-forward-tab)
(global-set-key (kbd "<f11>") 'tabbar-backward-tab)
(require 'tabbar)
;(setq tabbar-use-images nil)
(setq tabbar-separator (quote (1.5)))
;; hide for special buffers
;; 1- if remove-if is not found, add here (require 'cl)
;; 2- in my emacs 23, I had to remove the "b" from "lambda (b)"
(when (require 'tabbar nil t)
  ;(setq tabbar-buffer-groups-function
  ;      (lambda () (list "All Buffers")))
  (setq tabbar-buffer-list-function
        (lambda ()
          (remove-if
           (lambda(buffer)
             (find (aref (buffer-name buffer) 0) " *"))
           (buffer-list))))
  (tabbar-mode))
(tabbar-mode 1)


;;; dired+
;;; ------
(require 'dired+)
(diredp-toggle-find-file-reuse-dir 1)


;;; indent-guide
;;; ------------
(require 'indent-guide)
(indent-guide-global-mode)
(setq indent-guide-recursive t)


;;; evil-magit
;;; ----------
;;; * evil support for magit
;;; * https://github.com/justbur/evil-magit
(global-set-key (kbd "C-x g") 'magit-status)
(require 'evil-magit)


;;; git-gutter
;;; ----------
;;; * show git status for each line of editing file
;;; * https://github.com/syohex/emacs-git-gutter
(global-git-gutter-mode +1)


;;; helm
;;; ----
;;; * enable fuzzy search for files, commands and etc
;;; * https://github.com/emacs-helm/helm/wiki
(require 'helm-config)
;;; do things what helm can do with helm
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-c f") 'helm-recentf)
(helm-mode 1)


;;; flycheck-tip
;;; ------------
;;; * show flycheck message as tooltip beside current cursor
;;; * https://github.com/yuutayamada/flycheck-tip
(require 'flycheck-tip)
;; show flycheck error as popup instead of in echo area
;; deprecated
;(flycheck-tip-use-timer 'verbose)
(setq flycheck-tip-timer-delay 0.1) ; set delay to show tip
(setq flycheck-idle-change-delay 0.5) ; delay to check
(setq error-tip-notify-keep-messages t)


;;; markdown
;;; --------
;;; * syntax highlight and some utilities for markdown
;;; * http://jblevins.org/projects/markdown-mode/
;; use gfm-mode as default markdown-mode
;(autoload 'gfm-mode "gfm-mode"
;		  "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.gfm\\'" . gfm-mode))


;;; deft
;;; ----
;;; * easy doucment writter
;;; * shortcuts
;;;     - f8 : open deft
;;;     - C-c RET : create document with title
;;; * https://github.com/jrblevin/deft
(require 'deft)
(global-set-key (kbd "<f8>") 'deft) ; start deft with f8
(add-to-list 'evil-emacs-state-modes 'deft-mode) ; start deft in evil-insert-mode
(setq deft-default-extension "md") ; to set default extension as md (markdown)
(setq deft-ignore-file-regexp "flymd.*") ; ignore all made by flymd below


;;; language specific configurations from below


;;; -----------------------------------------------------------------------------------------------
;;; erlang
;;; -----------------------------------------------------------------------------------------------
;;; all below are erlang related package configurations


;;; erlang mode
;;; -----------
;;; * http://erlang.org/doc/apps/tools/erlang_mode_chapter.html
;; use the system wide default
;; TODO make work for both OS X and Arch
(setq load-path (cons "/usr/local/lib/erlang/lib/tools-2.8.2/emacs" load-path))
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(setq erlang-root-dir "/usr/local/lib/erlang")
(autoload 'erlang-start "erlang-start"
          "start Major mode for erlang development" t)
;(add-hook 'erlang-mode-hook 'linum-mode)


;;; edts
;;; ----
;;; * ide support for Erlang
;;; * run :edts-compile-deps manually when it raise exception at the first run
;;; * use 256 colors term for better syntax highlight
;;; * some convenient keys
;;;     - M-. : follow
;;;     - M-, : follow back
;;;     - C-c C-n : next issue
;;;     - C-c C-p : previous issue
;;;     - C-c C-d h : show documentation of current
;;;     - C-c C-d H : open documentation, 'q' to exit man page
;;;     - C-c C-d w : list callers
;;;     - C-c C-d e : edit all occurances in current buffer
;;;     - C-c C-d E : edit all occurances in current function
;;; * https://github.com/tjarvstrand/edts
(setq edts-man-root "/usr/local/opt/erlang-r18-legy/lib/erlang")
(add-hook 'erlang-mode-hook 'init-edts)
(defun init-edts ()
  "initialize erlang variables and start edts"
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (setq erlang-indent-level 2)
  (modify-syntax-entry ?_ "w") ; consider '_' as part of word
  (require 'edts-start)
  (edts-mode 1))


;;; -----------------------------------------------------------------------------------------------
;;; python
;;; -----------------------------------------------------------------------------------------------
; remove python-mode from targeted modes of which auto-complete is activated automatically by global-auto-complete-mode
(require 'auto-complete)
(setq ac-modes ())
(defun my-python-mode-hook ()
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  ;(auto-complete-mode 0) ; elpy prefer company over auto-complete so follow that :)
  (linum-mode) ; show line number
  )
(add-hook 'python-mode-hook 'my-python-mode-hook)


;;; elpy
;;; ----
;;; * https://github.com/jorgenschaefer/elpy
;;; * needs to install some packages via pip
;;;
;;;     $ pip install rope jedi flake8 importmagic autopep8 yapf
;;;
;;; * chosen elpy after much consideration between elpy and anaconda
;;;   since anaconda makes dead too many dead processes
(elpy-enable)
(setq elpy-rpc-backend "jedi")
(add-hook 'elpy-mode-hook 'init-elpy)
(defun init-elpy ()
  "initialize elpy for python"
  (setq elpy-rpc-backend "jedi")
  ; use flycheck instead of flymake
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (flycheck-mode)
  )


;;; -----------------------------------------------------------------------------------------------
;;; go
;;; -----------------------------------------------------------------------------------------------
;;; all below are golang related package configurations
;;; full process and explaination can be found in https://github.com/dominikh/go-mode.el


;;; go-mode
;;; -------
;;; * ide support for go
;;; * https://github.com/dominikh/go-mode.el
;(require 'go-mode-autoloads)
(require 'go-guru)
(defun my-go-mode-hook ()
  ; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding                                                      
  ;(local-set-key (kbd "M-.") 'godef-jump)
  ; use guru instead of godef which sometimes not works well
  (local-set-key (kbd "M-.") 'go-guru-definition)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  (local-set-key (kbd "C-c C-n") 'flycheck-tip-cycle) ; for flycheck
  (setq go-guru-hl-identifier-idle-time 0.1)
  (setq tab-width 4)
  (go-guru-hl-identifier-mode 1) ; to highlight current focused variable occurances
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)


;;; gocode
;;; ------
;;; * actually gocode is daemon(server) to server autocompletion for go
;;; * install:
;;;
;;;     $ go get -u github.com/nsf/gocode
;;;
;;; * so needs to install additional emacs packages working as a client
;;;   'go-autocomplete'
;;; * https://github.com/nsf/gocode
;;; * change package lookup mode
;;;   gb (https://github.com/constabulary/gb) works better
;;;
;;;     $ go get -u github.com/constabulary/gb/...
;;;     $ gocode set package-lookup-mode ~/Dev/go-workspace/bin/gb
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)


;;; go-eldoc
;;; --------
;;; * also dependent on 'gocode' (see comment above)
;;; * https://github.com/syohex/emacs-go-eldoc
(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)


;;; goflymake
;;; ---------
;;; * goflymake can not be installed via Melpa yet (mqybe later as well)
;;;   so run command below before setup
;;;
;;;     $ go get -u github.com/dougm/goflymake
;;;
;;; * and need to install 'flycheck'
;;; * needs to enable flycheck-mode manually
;;; * https://github.com/dougm/goflymake
;(add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/dougm/goflymake"))
(add-to-list 'load-path "/Users/yolongyi/Dev/go-workspace/src/github.com/dougm/goflymake")
(add-to-list 'load-path "/home/yolongyi/Dev/go-workspace/src/github.com/dougm/goflymake")
;(require 'go-flymake)
(require 'go-flycheck)
(add-hook 'go-mode-hook 'flycheck-mode)


;;; -----------------------------------------------------------------------------------------------
;;; scala
;;; -----------------------------------------------------------------------------------------------
(add-hook 'scala-mode-hook 'my-scala-hook)
(defun my-scala-hook ()
  "my initilization for scala"
  (linum-mode)
  )


;;; ensime
;;; ------
;;; * ide support for scala
;;; * some configuration should be done before use
;;; * shortcuts
;;;     - C+c C+c e : show errors
;;;     - C+c C+b ? : for sbt
;;; * http://ensime.github.io/
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime)
(setq ensime-typecheck-idle-interval 2)
(setq ensime-startup-snapshot-notification nil)
(add-to-list 'evil-emacs-state-modes 'ensime-search-mode) ; start ensime-search in evil-emacs-mode


;;; popup-imenu
;;; -----------
(require 'popup-imenu)
(setq popup-imenu-position 'center) ; show popup at point
(setq popup-imenu-style 'indent) ; show with hierarchy
;; shortcut
(global-set-key (kbd "C-c C-c o") 'popup-imenu)


;;; auto-generated-section
;;; ----------------------
;;; This section is auto generated by emacs


;;; -----------------------------------------------------------------------------------------------
;;; testing
;;; -----------------------------------------------------------------------------------------------

;;; -----------------------------------------------------------------------------------------------
;;; C/C++
;;; -----------------------------------------------------------------------------------------------

;;; https://www.emacswiki.org/emacs/CProgrammingLanguage

;;; cc-mode
;;; -------
(require 'cc-mode)

;;; c indentation
;;; -------------
;;; * c indentation style 'gnu'
;;;     - https://www.emacswiki.org/emacs/IndentingC
;;; * set indent level 4
(setq c-default-style "gnu"
      c-basic-offset 4)

;;; http://tuho.github.io/c-ide.html

;;; helm-gtags
;;; ----------
;;; * shortcuts
;;;     - M-. : follow
;;;     - M-, : back (after follow)
;;;     - C-c g r : find references for functions
;;;     - C-c g s : find references for variables 
;;;     - C-c g a : find functions that current functions call
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;; function-args
;;; -------------
;;; * used for moo-jump-local
;;;     - C-M-k
(fa-config-default)

;;; sr-speedbar
;;; -----------
(define-key helm-gtags-mode-map (kbd "C-c t") 'sr-speedbar-toggle)

;;; company
;;; -------
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;; use clang for completion
(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map [(tab)] 'company-complete)
(define-key c++-mode-map [(tab)] 'company-complete)
;; add this to .dir-locals.el to complete candidates for the project
;;(require 'company-clang)
;;(
;; (nil . ((company-clang-arguments . ("-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/"
;;                                     ))))
;; )

(semantic-add-system-include "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/")

;;; company-c-headers
;;; -----------------
;;; * for completion c++ header files
(require 'company-c-headers)
(add-to-list 'company-backends 'company-c-headers)
;; add this to .dir-locals.el
(add-to-list 'company-c-headers-path-system "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/4.2.1/")
;;(add-to-list 'company-c-headers-path-user "/usr/include/c++/4.8/")



;;; -----------------------------------------------------------------------------------------------
;;; Etc
;;; -----------------------------------------------------------------------------------------------

;;; flymd
;;; -----
;;; * preview writing markdown
;;; * simply execute 'flymd-flyit' in markdown-mode
;;; * https://github.com/mola-T/flymd
(defun my-flymd-browser-function (url) ; use firefox due to browser compatibility issue
  (let ((process-environment (browse-url-process-environment)))
    (apply 'start-process
           (concat "firefox " url)
           nil
           "/usr/bin/open"
           (list "-a" "firefox" url))))
(setq flymd-browser-open-function 'my-flymd-browser-function)


;;; -----------------------------------------------------------------------------------------------
;;; recycle bin
;;; -----------------------------------------------------------------------------------------------
;;; old configuration but keeps for just in case


;;; tabbar-ruler
;;; ------------
;;; * prettier tabbar like the one in Aquaemacs but a bit slow
;;; * https://github.com/mattfidler/tabbar-ruler.el
;(setq tabbar-ruler-global-tabbar t)    ; get tabbar
;;(setq tabbar-ruler-global-ruler t)     ; get global ruler
;;(setq tabbar-ruler-popup-menu t)       ; get popup menu.
;(setq tabbar-ruler-popup-toolbar t)    ; get popup toolbar
;(setq tabbar-ruler-popup-scrollbar t)  ; show scroll-bar on mouse-move
;(require 'tabbar-ruler)
;(global-set-key (kbd "<f6>") 'tabbar-ruler-tabbar-forward-group)
;(global-set-key (kbd "<f7>") 'tabbar-ruler-tabbar-backward-group)
;(global-set-key (kbd "<f12>") 'tabbar-ruler-tabbar-forward-tab)
;(global-set-key (kbd "<f11>") 'tabbar-ruler-tabbar-backward-tab)


;;; jedi
;;; ----
;;; * auto completion for python
;;; * needs to run 'M-x jedi:install-server'
;;;   to setup properly
;;; * http://tkf.github.io/emacs-jedi/latest/
;(add-hook 'python-mode-hook 'jedi:setup)
;(setq jedi:complete-on-dot t)
;(setq jedi:get-in-function-call-delay 50)
;(setq jedi:get-in-function-call-timeout 1000)


;;; anaconda-mode
;;; -------------
;;; * ide support for python
;;; * https://github.com/proofit404/anaconda-mode
;;; * chosed elpy after so long consideration between elpy and anaconda
;;;   since anaconda makes dummy zombie process internally
;(defun anaconda-python-mode-hook ()
;  (anaconda-mode)
;  (company-mode) ; to enable autocomplete through company-anaconda
;  (anaconda-eldoc-mode))
;(add-hook 'python-mode-hook 'anaconda-python-mode-hook)


;;; company-anaconda
;;; ----------------
;;; * company support for anaconda
;(eval-after-load "company"
;                 '(add-to-list 'company-backends 'company-anaconda))


;;; wanderlust
;;; ----------
;(autoload 'wl "wl" "Wanderlust" t)
