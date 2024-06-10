;;; init-whichkey.el
;;; Commentary:
;;; Code:

(require-package 'which-key)
(add-hook 'after-init-hook 'which-key-mode)

(defvar my-show-which-key-when-press-C-h nil)
(with-eval-after-load 'which-key
  (setq which-key-allow-imprecise-window-fit t) ; performance
  (setq which-key-separator ":")
  (setq which-key-idle-delay 0.02)
  (when my-show-which-key-when-press-C-h
    ;; @see https://twitter.com/bartuka_/status/1327375348959498240?s=20
    ;; Therefore, the which-key pane only appears if I hit C-h explicitly.
    ;; C-c <C-h> for example - by Wanderson Ferreira
    (setq which-key-idle-delay 0.02)
    (setq which-key-show-early-on-C-h t))
  (setq which-key-idle-secondary-delay 0.02))