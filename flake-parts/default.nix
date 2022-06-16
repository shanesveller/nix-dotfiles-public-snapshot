_inputs: {
  imports = [
    # Order-sensitive
    ./overlays.nix
    # Order-independent
    ./checks.nix
    ./darwin.nix
    ./devshell.nix
    ./emacs.nix
    ./gcroots.nix
    ./home-manager.nix
    ./nixos.nix
    ./packages.nix
  ];
}
