{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [
      ardour
      libsForQt5.kdenlive
      krita
      lmms
      milkytracker
      obs-studio
    ];
  };
}
