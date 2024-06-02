;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:


;; -----------------
;; DEBUGGING AND VERSION CHECK
;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;; debug-on-error: Uncommenting this line enables detailed backtraces when errors occur, useful for debugging.
;; The let block checks if the Emacs version is at least 27.1, otherwise it throws an error. It also warns if the version is below 28.1, indicating that some features might be disabled.

;;(setq debug-on-error t)

(let ((minver "27.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "28.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))


;; -----------------
;; LOAD PATH AND BENCHMARKING
;; Adds a lisp directory inside the user's Emacs directory to the load path.
;; Requires init-benchmarking.el, which is presumably used to measure and report Emacs startup time.

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time


;; -----------------
;; CONSTANTS
;; *spell-check-support-enabled*: This constant controls whether spell-check support is enabled.
;; *is-a-mac*: This constant checks if the system type is macOS (Darwin).

(defconst *spell-check-support-enabled* t) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))


;; -----------------
;; GARBAGE COLLECTION AND PERFORMANCE TUNING
;; Adjusts garbage collection threshold to 128 MB for better performance during startup.
;; Sets maximum process output read size and disables adaptive read buffering for processes.

;; Adjust garbage collection threshold for early startup (see use of gcmh below)
(setq gc-cons-threshold (* 128 1024 1024))


;; Process performance tuning

(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)


;; -----------------
;; BOOTSTRAPS CONFIG
;; Sets the location of the custom file, custom.el.
;; Requires several initialization files for utilities, site-specific configurations, package management, and environment path setup.

(setq custom-file (locate-user-emacs-file "custom.el"))
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH


;; -----------------
;; GENERAL PERFORMANCE TUNING
;; Requires and configures gcmh (Garbage Collector Magic Hack) for more efficient garbage collection.
;; Sets jit-lock-defer-time to 0 to avoid delaying font locking.

(when (require-package 'gcmh)
  (setq gcmh-high-cons-threshold (* 128 1024 1024))
  (add-hook 'after-init-hook (lambda ()
                               (gcmh-mode)
                               (diminish 'gcmh-mode))))

(setq jit-lock-defer-time 0)


;; -----------------
;; Optional Preload Local Configuration
;; Optionally requires init-preload-local.el if it exists, allowing for user-specific preloading configurations.
;; Allow users to provide an optional "init-preload-local.el"
(require 'init-preload-local nil t)

;; -----------------
;; FEATURE AND MODE CONFIGURATION
;; Load configs for specific features and modes
;; Requires various feature and mode-specific configuration files, enabling and configuring a wide array of Emacs packages and settings.
;; The (maybe-require-package 'package-name) lines conditionally load packages if available.
(require-package 'diminish)
(maybe-require-package 'scratch)
(require-package 'command-log-mode)

(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-themes)
(require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-dired)
(require 'init-isearch)
(require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flymake)
(require 'init-eglot)

(require 'init-recentf)
(require 'init-minibuffer)
(require 'init-hippie-expand)
(require 'init-corfu)
(require 'init-windows)
(require 'init-sessions)
(require 'init-mmm)

(require 'init-editing-utils)
(require 'init-whitespace)
(require 'init-evil)

(require 'init-vc)
(require 'init-darcs)
(require 'init-git)
(require 'init-github)

(require 'init-projectile)

(require 'init-compile)
(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
(require 'init-erlang)
(require 'init-javascript)
(require 'init-org)
(require 'init-nxml)
(require 'init-html)
(require 'init-css)
(require 'init-haml)
(require 'init-http)
(require 'init-python)
(require 'init-haskell)
(require 'init-elm)
(require 'init-purescript)
(require 'init-ruby)
(require 'init-rails)
(require 'init-sql)
(require 'init-ocaml)
(require 'init-j)
(require 'init-nim)
(require 'init-rust)
(require 'init-toml)
(require 'init-yaml)
(require 'init-docker)
(require 'init-terraform)
(require 'init-nix)
(maybe-require-package 'nginx-mode)
(maybe-require-package 'just-mode)
(maybe-require-package 'justl)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-sly)
(require 'init-clojure)
(require 'init-clojure-cider)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-misc)

(require 'init-folding)
(require 'init-dash)

(require 'init-ledger)
(require 'init-lua)
(require 'init-uiua)
(require 'init-terminals)


;; -----------------
;; EXTRA PACKAGES
;; Extra packages which don't require any configuration
;; Requires additional packages for extended functionality (e.g., sudo-edit, gnuplot, htmlize).
;; Conditional loading for macOS-specific packages and optional packages.

(require-package 'sudo-edit)
(require-package 'gnuplot)
(require-package 'htmlize)
(when *is-a-mac*
  (require-package 'osx-location))
(maybe-require-package 'dotenv-mode)
(maybe-require-package 'shfmt)

(when (maybe-require-package 'uptimes)
  (setq-default uptimes-keep-count 200)
  (add-hook 'after-init-hook (lambda () (require 'uptimes))))

(when (fboundp 'global-eldoc-mode)
  (add-hook 'after-init-hook 'global-eldoc-mode))

(require 'init-direnv)

(when (and (require 'treesit nil t)
           (fboundp 'treesit-available-p)
           (treesit-available-p))
  (require 'init-treesitter))


;; -----------------
;; EMACSCLIENT AND CUSTOM SETTINGS
;; Allow access from emacsclient
;; Configures Emacs to start the server for emacsclient if not already running.
;; Loads custom settings from custom.el if the file exists.
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

;; Variables configured via the interactive 'customize' interface
(when (file-exists-p custom-file)
  (load custom-file))

;; -----------------
;; LOCALES AND USER SETTINGS
;; Requires init-locales.el for locale settings.
;; Optionally requires init-local.el for user-specific settings.
;; Locales (setting them earlier in this file doesn't work in X)
(require 'init-locales)

;; Allow users to provide an optional "init-local" containing personal settings
(require 'init-local nil t)


;; -----------------
(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
