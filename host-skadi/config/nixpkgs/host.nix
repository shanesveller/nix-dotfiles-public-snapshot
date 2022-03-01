{ config, flake, pkgs, ... }: {
  programs.shanesveller = {
    work.enable = true;

    bash.enable = true;
    fish.enable = true;
    fish.omf = true;
    fish.starship = true;
    zsh.enable = true;

    emacs = {
      doom = true;
      enable = true;
      package = flake.packages.x86_64-darwin.emacs;
      latex = false;
    };
    vim.enable = true;
    wakatime.enable = true;

    email.enable = false;

    git.enable = true;
    git.work = true;
    git.workIgnores = [ ".dir-locals.el" ];
    local.enable = true;
    local.home = false;
    lorri.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = true;
    utilities.enable = true;
    utilities.direnv = true;
    utilities.work = true;

    elixir.enable = false;
    # https://github.com/elixir-lang/elixir/releases
    elixir.elixirVersion = "1.11.3";
    # https://github.com/erlang/otp/releases/
    elixir.erlangVersion = "23.2.3";
    go.enable = false;
    go.package = pkgs.go_1_15;
    kube.enable = false;
    kube.home = false;
    node.enable = false;
    rust.enable = true;
    rust.sccache = false;

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
