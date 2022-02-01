;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;; [[file:config.org::*BEAM][BEAM:1]]
(add-hook! 'straight-use-package-pre-build-functions
  (defun +shanesveller-shrink-otp (package &rest _)
    (when (equal package "erlang")
      (let ((default-directory (straight--repos-dir "otp")))
        (unless (eq 0 (shell-command "git config --local --get extensions.worktreeconfig"))
            (shell-command "git sparse-checkout init --cone"))
        (shell-command "git sparse-checkout set lib/tools/emacs && git sparse-checkout reapply")))))

(package! alchemist :disable t)
;; BEAM:1 ends here

;; [[file:config.org::*Frontend][Frontend:1]]
(package! coffee-mode :disable t)
;; Frontend:1 ends here

;; [[file:config.org::*Docker][Docker:1]]
(when (eq system-type 'darwin)
  (disable-packages! docker docker-tramp))
;; Docker:1 ends here

;; [[file:config.org::*Kubernetes][Kubernetes:1]]
(package! jsonnet-mode :pin "d188745d1b42e1a28723dade1e5f7caf1282cb01")
;; Kubernetes:1 ends here

;; [[file:config.org::*org-mode][org-mode:1]]
(package! org-drill
  :pin "bf8fe812d44a3ce3e84361fb39b8ef28ca10fd0c")

(package! org-edna
  :pin "de6454949045453e0fa025e605b445c3ca05c62a")
;; org-mode:1 ends here

;; [[file:config.org::*Code-review][Code-review:1]]
(package! code-review :disable t)
;; Code-review:1 ends here

;; [[file:config.org::*Just][Just:1]]
(package! just-mode
  :pin "8cf9e686c8c7bb725c724b5220a4a3ed17d005d0")
;; Just:1 ends here
