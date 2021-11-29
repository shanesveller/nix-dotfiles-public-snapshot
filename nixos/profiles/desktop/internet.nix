{ pkgs, ... }:

{
  programs.chromium.enable = true;

  users.users.shane = {
    packages = with pkgs; [
      dropbox-cli
      firefox
      google-chrome
      nyxt
      qutebrowser
      thunderbird
    ];
  };
}
