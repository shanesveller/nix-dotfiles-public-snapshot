{ config, flake, pkgs, ... }: {
  programs.shanesveller = {
    home.enable = false;

    bash.enable = false;
    fish.enable = true;
    fish.omf = false;
    fish.starship = false;
    zsh.enable = false;

    emacs = {
      doom = true;
      enable = true;
      package = pkgs.emacs-nox;
      latex = false;
    };
    vim.enable = true;

    git.enable = true;
    git.pre-commit = false;
    local.enable = false;
    local.home = false;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = false;
    utilities.enable = false;
    utilities.direnv = false;
    utilities.unfree = false;

    kube.enable = false;
    kube.home = false;

    data = {
      enable = false;

      repos = {
        asdf = {
          branch = "v0.9.0";
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
