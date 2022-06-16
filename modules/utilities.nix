{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.utilities;
in {
  # TODO: option for overlay, or extract overlay
  options.programs.shanesveller.utilities = {
    enable = mkEnableOption "Utilities";
    direnv = mkEnableOption "Direnv Overlay";
    home = mkEnableOption "Home-specific utilities";
    nextgen = mkEnableOption "Next-gen utilities (mostly rust)";
    unfree = mkEnableOption "Unfree utilities";
    work = mkEnableOption "Work-specific utilities";
  };

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
      pinentryFlavor = "gtk2";
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
        entr
        graphviz
        # httpie # 22.05 BROKEN (python3 pyopenssl)
        ipcalc
        jid
        jo
        mtr
        ncdu
        nmap
        openssh # ssh-copy-id included
        pstree
        pv
        pwgen
        readline
        rename
        ripgrep
        shellcheck
        speedtest-cli
        sqlite
        tldr
        tree
        watch
        watchexec
      ] ++ pkgs.lib.optionals (cfg.nextgen) [
        bandwhich
        bat
        bottom
        delta
        difftastic
        diskus
        du-dust
        exa
        fd
        gitui
        jless
        just
        miniserve
        procs
        tokei
        xsv
        zellij
      ] ++ pkgs.lib.optionals (cfg.home) [
        inetutils # telnet
      ] ++ pkgs.lib.optionals (cfg.work) [ ]
      ++ pkgs.lib.optional (stdenv.isDarwin) pinentry_mac
      ++ pkgs.lib.optionals (stdenv.isLinux) (with pkgs; [ _1password t-rec ]);
  };
}
