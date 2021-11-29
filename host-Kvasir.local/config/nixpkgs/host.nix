{ config, pkgs, ... }: {
  home.homeDirectory = "/Users/shane";
  home.username = "shane";

  programs.shanesveller = {
    home.enable = true;

    bash.enable = true;
    fish.enable = true;
    fish.omf = true;
    fish.starship = true;
    zsh.enable = true;

    emacs = {
      doom = true;
      enable = true;
      package = pkgs.emacsGcc;
      latex = false;
    };
    vim.enable = true;
    wakatime.enable = true;

    email.enable = true;

    git.enable = true;
    local.enable = true;
    local.home = true;
    lorri.enable = true;
    media.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = true;
    utilities.enable = true;
    utilities.direnv = true;

    elixir.enable = false;
    # https://github.com/elixir-lang/elixir/releases
    elixir.elixirVersion = "1.10.4";
    # https://github.com/erlang/otp/releases/
    elixir.erlangVersion = "22.3.4.4";
    go.enable = false;
    go.package = pkgs.go_1_15;
    kube.enable = true;
    kube.home = true;
    rust.enable = true;
    rust.sccache = false;
    # rust.moz_overlay = true;

    data = {
      enable = true;

      repos = {
        asdf = {
          branch = "v0.8.1";
          repo = "https://github.com/asdf-vm/asdf.git";
          target = "${config.home.homeDirectory}/.asdf";
        };

        doom = {
          branch = "develop";
          repo = "https://github.com/hlissner/doom-emacs.git";
          target = "${config.xdg.configHome}/emacs";
        };
      };
    };
  };
}
