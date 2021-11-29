{ config, pkgs, ... }: {
  programs.shanesveller = {
    home.enable = true;

    bash.enable = true;
    fish.enable = true;
    fish.omf = false;
    fish.starship = true;
    zsh.enable = true;

    emacs = {
      doom = true;
      enable = true;
      package = pkgs.emacsPgtkGcc;
      latex = false;
    };
    vim.enable = true;

    git.enable = true;
    local.enable = true;
    local.home = true;
    lorri.enable = false;
    ssh.enable = true;
    tmux.enable = true;
    tmux.emacs = false;
    utilities.enable = true;
    utilities.direnv = true;

    kube.enable = true;
    kube.home = true;

    data = {
      enable = false;

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
