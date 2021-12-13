;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; [[file:config.org::*Theme][Theme:1]]
(setq doom-theme 'doom-tomorrow-night)
;; Theme:1 ends here

;; [[file:config.org::*Font][Font:1]]
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font Mono")
      doom-unicode-font (font-spec :family "FiraCode Nerd Font Mono" :size 16)
      doom-big-font (font-spec :family "FiraCode Nerd Font Mono" :size 19))
;; Font:1 ends here

;; [[file:config.org::*Literate Config][Literate Config:1]]
(setq doom-private-dir (file-truename "~/.dotfiles/config/doom/"))

(when (featurep! :config literate)
       (defun my-doom/goto-private-literate-file ()
         "Open my private config.org file."
         (interactive)
         (find-file (concat doom-private-dir "config.org")))
       (map! (:map doom-leader-open-map
              "c" 'my-doom/goto-private-literate-file)))
;; Literate Config:1 ends here

;; [[file:config.org::*OS Compatibility][OS Compatibility:1]]
(after! pdf-tools
  (advice-remove '+pdf--install-epdfinfo-a #'pdf-view-mode)
  (setq pdf-tools-installer-os "nixos"))
;; OS Compatibility:1 ends here

;; [[file:config.org::*Which-key timing][Which-key timing:1]]
(after! which-key
  (setq which-key-idle-delay 0.8
        which-key-idle-secondary-delay 0.4))
;; Which-key timing:1 ends here

;; [[file:config.org::*Window Management][Window Management:1]]
(after! evil
  (setq evil-split-window-below t
        evil-vsplit-window-right t))
;; Window Management:1 ends here

;; [[file:config.org::*Magit][Magit:1]]
(after! forge
  (setq forge-owned-accounts '(("shanesveller" . "personal"))))

(after! magit
  (setq magit-repository-directories '(("~/Dropbox/org" . 0)
                                       ("~/src" . 1)
                                       ("~/src/infra" . 1)
                                       ("~/src/not_me" . 1)
                                       ("~/src/side-projects" . 2))))
;; Magit:1 ends here

;; [[file:config.org::*Forge Auth][Forge Auth:1]]
(when (featurep! :tools magit +forge)
  (add-to-list 'auth-sources (concat doom-private-dir "authinfo.gpg") t))
;; Forge Auth:1 ends here

;; [[file:config.org::*Git Absorb support][Git Absorb support:1]]
(when (featurep! :tools magit)
  (after! magit
    (transient-replace-suffix 'magit-commit 'magit-commit-autofixup
      '("x" "Absorb changes" magit-commit-absorb))))
;; Git Absorb support:1 ends here

;; [[file:config.org::*Project Management][Project Management:1]]
(after! persp-mode
  (setq +workspaces-switch-project-function 'magit-status))

(after! prodigy
  (map! :leader
        :desc "Prodigy process mgmt" "o y" #'prodigy))

(after! projectile
  (setq projectile-project-search-path '("~/src")))
;; Project Management:1 ends here

;; [[file:config.org::*Terminal Support][Terminal Support:1]]
(when (featurep! :term vterm)
  (after! vterm
    (if-let (fish-path (executable-find "fish"))
        (setq vterm-shell fish-path))))
;; Terminal Support:1 ends here

;; [[file:config.org::*BEAM][BEAM:1]]
(when (and (featurep! :lang elixir) (featurep! :tools lsp))
  (after! elixir-mode
    (remove-hook 'elixir-mode-local-vars-hook #'lsp!)
    (set-docsets! 'elixir-mode "Elixir" "Erlang")))
;; BEAM:1 ends here

;; [[file:config.org::*Nix][Nix:1]]
(when (and (featurep! :completion company) (featurep! :lang nix))
  (after! company
    (setq-hook! 'nix-mode-hook company-idle-delay nil)))
;; Nix:1 ends here

;; [[file:config.org::*Infrastructure as Code][Infrastructure as Code:1]]
(use-package! jsonnet-mode)
;; Infrastructure as Code:1 ends here

;; [[file:config.org::*PlantUML][PlantUML:1]]
(when (featurep! :lang plantuml)
  (after! plantuml
    (setq plantuml-default-exec-mode 'jar
          ;; plantuml-jar-path (f-expand "~/bin/plantuml.jar")
          plantuml-server-url "http://localhost:8080")))
;; PlantUML:1 ends here

;; [[file:config.org::*Rust][Rust:1]]
(when (featurep! :lang rust)
  (after! rustic
    (if (executable-find "rust-analyzer")
        (setq rustic-lsp-server 'rust-analyzer
              lsp-rust-analyzer-cargo-watch-command "clippy"
              lsp-rust-analyzer-display-chaining-hints t
              lsp-rust-analyzer-display-parameter-hints t))))
;; Rust:1 ends here

;; [[file:config.org::*Just][Just:2]]
(when (featurep! :lang rust)
       (use-package! just-mode
         :mode "justfile\\'"))
;; Just:2 ends here

;; [[file:config.org::*YAML][YAML:1]]
(when (featurep! :lang yaml)
  (after! auto-fill
    (add-hook 'yaml-mode-hook #'turn-off-auto-fill)))
;; YAML:1 ends here

;; [[file:config.org::*Org ecosystem][Org ecosystem:1]]
(when (featurep! :lang org)
  (setq! org-directory (file-truename "~/Dropbox/org/")
         org-agenda-files `(,org-directory))

  (after! org
    (add-to-list 'org-modules 'org-drill t)
    (defun org-roam-jump-to-index ()
      "Jump to org-roam Index"
      (interactive)
      (org-roam-node-find nil "Index"))
    (map!
     (:when (featurep! :lang org +brain)
      (:map doom-leader-open-map
       "B" 'org-brain-visualize)
      (:map org-mode-map
       :localleader
       "B" 'org-brain-visualize))
     (:when (featurep! :lang org +roam2)
      (:map doom-leader-notes-map
       "r J" 'org-roam-jump-to-index))))
  (after! org-drill
    (defalias 'first (symbol-function 'cl-first)))

  (use-package! org-edna
    :after (org)
    :config (org-edna-mode +1)))
;; Org ecosystem:1 ends here

;; [[file:config.org::*org-roam][org-roam:1]]
(when (featurep! :lang org +roam2)
  (setq org-roam-directory (file-truename "~/Dropbox/org/roam")))
;; org-roam:1 ends here

;; [[file:config.org::*Emacs from git with General][Emacs from git with General:1]]
(after! general
  (general-auto-unbind-keys :off)
  (remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys))
;; Emacs from git with General:1 ends here

;; [[file:config.org::*Elixir LSP formatting][Elixir LSP formatting:1]]
(when (and (featurep! :lang elixir) (featurep! :tools lsp))
  (setq-hook! 'elixir-mode-hook +format-with-lsp nil))
;; Elixir LSP formatting:1 ends here

;; [[file:config.org::*Frontend LSP formatting][Frontend LSP formatting:1]]
(when (featurep! :lang javascript)
  (setq-hook! '(rjsx-mode-hook typescript-mode-hook typescript-tsx-mode-hook) +format-with-lsp nil))
;; Frontend LSP formatting:1 ends here

;; [[file:config.org::*Formatter from Direnv][Formatter from Direnv:1]]
(when (and (featurep! :editor format) (featurep! :tools direnv))
  (after! format-all
    (advice-add 'format-all-buffer--with :around #'envrc-propagate-environment)))
;; Formatter from Direnv:1 ends here

;; [[file:config.org::*TTY][TTY:1]]
(when (featurep! :os tty)
  (remove-hook! 'tty-setup-hook #'(evil-terminal-cursor-changer-activate xterm-mouse-mode)))
;; TTY:1 ends here
