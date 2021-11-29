{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [ alacritty calibre heaptrack kitty pinentry xclip ];
  };

}
