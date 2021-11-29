{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.vim;
in {
  options.programs.shanesveller.vim.enable = mkEnableOption "Vim";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      configure = { };
      extraConfig = builtins.concatStringsSep "\n" [
        "source ${pkgs.vimPlugins.vim-plug.rtp}/plug.vim"
        (lib.strings.fileContents ./init.vim)
      ];
      extraPackages = with pkgs; [ fzf ];

      plugins = with pkgs.vimPlugins; [
        ale
        async-vim
        asyncomplete-vim
        csapprox
        delimitMate
        emmet-vim
        fzf-vim
        indentLine
        molokai
        nerdtree
        rust-vim
        tagbar
        typescript-vim
        ultisnips
        vim-airline
        vim-airline-themes
        vim-commentary
        vim-fugitive
        vim-gitgutter
        vim-lsp
        vim-misc
        vim-plug
        vim-rhubarb
        vim-snippets
        yats-vim
      ];

      withNodeJs = false;
      withPython3 = true;
      withRuby = false;
    };

    xdg.configFile."nvim/snapshot.vim".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/vim/snapshot.vim";
  };
}
