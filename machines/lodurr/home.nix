{ config, flake, pkgs, ... }: {
  home.homeDirectory = "/Users/shanesveller";
  home.username = "shanesveller";

  home.packages = [ pkgs.ffmpeg_4 ];

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
      package = flake.packages.${pkgs.system}.emacs;
      latex = false;
    };
    vim.enable = true;

    git.enable = true;
    git.pre-commit = false;
    git.work = true;
    local.enable = false;
    local.home = false;
    media.enable = false;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = true;
    tmux.personalProjects = { "dotfiles" = "~/.dotfiles"; };
    tmux.workProjects = { "dscout" = "~/src/dscout/dscout"; };
    utilities.enable = true;
    utilities.direnv = true;
    utilities.nextgen = true;
    utilities.unfree = true;

    elixir.enable = false;
    # https://github.com/elixir-lang/elixir/releases
    elixir.elixirVersion = "1.10.4";
    # https://github.com/erlang/otp/releases/
    elixir.erlangVersion = "22.3.4.4";

    data = {
      enable = true;

      repos = {
        asdf = {
          branch = "v0.10.1";
          repo = "https://github.com/asdf-vm/asdf.git";
          target = "${config.home.homeDirectory}/.asdf";
        };

        doom = {
          branch = "master";
          repo = "https://github.com/hlissner/doom-emacs.git";
          target = "${config.xdg.configHome}/emacs";
        };
      };
    };
  };
}
