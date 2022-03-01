{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.utilities;
in {
  # TODO: option for overlay, or extract overlay
  options.programs.shanesveller.utilities.enable = mkEnableOption "Utilities";
  options.programs.shanesveller.utilities.direnv =
    mkEnableOption "Direnv Overlay";
  options.programs.shanesveller.utilities.home =
    mkEnableOption "Home-specific utilities";
  options.programs.shanesveller.utilities.work =
    mkEnableOption "Work-specific utilities";

  config = mkIf cfg.enable {
    programs.bat.enable = true;
    programs.fzf.enable = true;
    programs.zoxide.enable = true;
    programs.zoxide.options = [ "--hook pwd" ];

    programs.gpg = {
      enable = pkgs.stdenv.isDarwin;
      settings = {
        default-key = "F83C407CADC45A0F1F2F44E89210C218023C15CD";
        # use-agent
        # no-emit-version
        # no-tty
      };
    };
    programs.htop = lib.mkMerge [
      { enable = true; }
      (if (config.programs.htop ? settings) then {
        settings = {
          hide_kernel_threads = true;
          hide_threads = true;
          hide_userland_threads = true;
          highlight_base_name = true;
        };
      } else {
        hideKernelThreads = true;
        hideThreads = true;
        hideUserlandThreads = true;
        highlightBaseName = true;
      })
    ];

    programs.jq = { enable = true; };

    programs.lsd.enable = pkgs ? lsd;
    programs.skim.enable = (pkgs ? fd && pkgs ? skim);
    programs.taskwarrior.enable = false;

    services.gpg-agent = {
      enable = pkgs.stdenv.isLinux;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      defaultCacheTtl = 3600;
      enableSshSupport = true;
      maxCacheTtl = 7200;
      pinentryFlavor = "gnome3";
    };

    home.file = mkIf pkgs.stdenv.isDarwin {
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 3600
        max-cache-ttl 7200

        enable-ssh-support
      '';
    };

    home.packages = with pkgs;
      [
        ag # the-silver-searcher
        asciinema
        awscli2
        bashInteractive
        # coreutils # want g (GNU) prefix on binaries via Homebrew
        ctags
        diskus
        entr
        fd
        gist
        git
        graphviz
        httpie
        ipcalc
        jid
        jless
        jo
        mr # lags in nix
        mtr
        ncdu
        nmap
        nss # mkcert
        openssh # ssh-copy-id included
        # pinentry_emacs
        pstree
        pv
        pwgen
        rcm
        readline
        rename
        ripgrep # compiles from source?
        shellcheck
        silver-searcher
        socat
        sops
        speedtest-cli
        sqlite
        tldr
        tokei # fails in nix release-19.03?
        tree
        # truncate # not present in nix
        watch
        watchexec # not present in nix
        wrk
        zellij
        # TODO: cross-module config lookup
      ] ++ pkgs.lib.optionals (cfg.home) [
        ansible
        exercism
        fdupes
        hugo # lags in nix
        pandoc # lags in nix
        pre-commit
        restic # lags in nix
        telnet
      ] ++ pkgs.lib.optionals (cfg.work) [ bitwarden-cli ]
      ++ pkgs.lib.optional (stdenv.isDarwin) pinentry_mac
      ++ pkgs.lib.optionals (stdenv.isLinux) (with pkgs; [ _1password t-rec ]);

    # TODO: Overlay
    # nixpkgs.overlays =
    #   mkIf (cfg.direnv) [ (self: super: { direnv = legacy.direnv; }) ];
  };
}
