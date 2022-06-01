{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [ dropbox-cli firefox thunderbird ];
  };
}
