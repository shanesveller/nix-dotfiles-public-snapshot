{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cachix
    hydra-check
    gitMinimal
    nix-tree
  ];
  nix.extraOptions = ''
    keep-derivations = true
    keep-outputs = true
  '';
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "02:00" ];
}
