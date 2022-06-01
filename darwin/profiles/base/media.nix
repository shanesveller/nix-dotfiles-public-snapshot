{ pkgs, ... }: { services.mopidy = { enable = !pkgs.stdenv.isDarwin; }; }
