{ config, pkgs, ... }: {
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
      # TODO: Overlay
      package = pkgs.emacsPgtkGcc;
      latex = true;
    };
    vim.enable = true;
    wakatime.enable = false;

    # TODO: Fix maildirBasePath
    email.enable = false;

    git.enable = true;
    local.enable = true;
    local.home = true;
    lorri.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = true;
    utilities.enable = true;
    elixir.enable = false;
    elixir.nixBuild = true;
    # https://github.com/elixir-lang/elixir/releases
    elixir.elixirVersion = "1.12.0";
    # https://github.com/erlang/otp/releases/
    elixir.erlangVersion = "24.0";
    go.enable = true;
    go.package = pkgs.go_1_15;
    kube.enable = true;
    kube.home = true;
    media.enable = true;
    node.enable = true;
    rust.enable = true;
    rust.sccache = false;

    # NixOS/Linux only
    wm.bspwm.enable = true;
    wm.polybar.enable = true;
    wm.sxhkd.enable = true;

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
