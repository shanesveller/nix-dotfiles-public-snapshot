{ pkgs, ... }: {
  imports = [
    ./db.nix
    # ./media.nix
    # ./nixops.nix
    # ./wm.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.nushell ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.dotfiles";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nixUnstable;
  nix.trustedUsers = [ "@admin" "@staff" ];
  nix.extraOptions = ''
    auto-optimise-store = false
    builders-use-substitutes = true
    experimental-features = nix-command flakes
    keep-derivations = true
    keep-outputs = true
  '';
  nix.nixPath = [
    # { nixpkgs = pkgs; }
  ];
  nix.binaryCaches = [
    # included by default
    # "https://cache.nixos.org"
    # "https://all-hies.cachix.org"
    # "https://cachix.cachix.org"
    # "https://hercules-ci.cachix.org"
    "https://nix-community.cachix.org"
    # "https://niv.cachix.org"
    # "https://pre-commit-hooks.cachix.org"
    "https://shanesveller.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    # included by default
    # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    # https://all-hies.cachix.org/
    "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
    # https://cachix.cachix.org
    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    # https://hercules-ci.cachix.org/
    "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
    # https://app.cachix.org/cache/nix-community
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # https://niv.cachix.org/
    "niv.cachix.org-1:X32PCg2e/zAm3/uD1ScqW2z/K0LtDyNV7RdaxIuLgQM="
    # https://pre-commit-hooks.cachix.org
    "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    # https://shanesveller.cachix.org/
    "shanesveller.cachix.org-1:SzmUXrd5XqRW5dQzm2dT6CJjT7/iudnoLzOAHj8hK6o="
  ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [ bashInteractive fish nushell zsh ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  nix.buildCores = 1;
}
