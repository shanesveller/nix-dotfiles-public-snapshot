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
(package! jsonnet-mode :pin "63c0f44fe7b5a333173235db7102ef8c2ae0b006")
;; Kubernetes:1 ends here

;; [[file:config.org::*org-mode][org-mode:1]]
(package! org-drill
  :pin "bf8fe812d44a3ce3e84361fb39b8ef28ca10fd0c")

(package! org-edna
  :pin "de6454949045453e0fa025e605b445c3ca05c62a")
;; org-mode:1 ends here

;; [[file:config.org::*Just][Just:1]]
(package! just-mode
  :pin "45c248fe72d4a15c5a9f26bc0b27adb874265f53")
;; Just:1 ends here
