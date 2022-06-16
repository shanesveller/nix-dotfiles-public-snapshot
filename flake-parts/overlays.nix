{ inputs, lib, self, ... }:
let
  overlay = final: prev: {
    inherit (self.outputs.packages.${prev.system}) cargo-hack cargo-nextest;
  };

  chooseNewer = left: right:
    if (builtins.compareVersions left.version right.version) > 0 then
      left
    else
      right;
  fromNestedIfNewer = nested_key: name:
    (final: prev:
      builtins.listToAttrs [{
        inherit name;
        value = chooseNewer (builtins.getAttr name prev)
          (builtins.getAttr name prev.${nested_key});
      }]);
  fromMasterIfNewer = fromNestedIfNewer "master";
  fromUnstableIfNewer = fromNestedIfNewer "unstable";

  masterPackages = [ "discord" ];
  rosettaPackages = [ "watchexec" "wrk" ];
  unstablePackages = [
    "datagrip"
    "nix-direnv"
    "polybar"
    "rust-analyzer"
    "tailscale"
    "thunderbird"
  ];

  masterOverlays = builtins.listToAttrs (builtins.map
    (name: lib.attrsets.nameValuePair "master-${name}" (fromMasterIfNewer name))
    masterPackages);

  rosettaOverlays = builtins.listToAttrs (builtins.map (name:
    lib.attrsets.nameValuePair "rosetta-${name}" (final: prev: {
      ${name} = inputs.nixpkgs.legacyPackages.x86_64-darwin.${name};
    })) rosettaPackages);

  unstableOverlays = builtins.listToAttrs (builtins.map (name:
    lib.attrsets.nameValuePair "unstable-${name}" (fromUnstableIfNewer name))
    unstablePackages);

  uniqueOverlays = {
    unstable-1password = final: prev: {
      inherit (prev.unstable) _1password;
      # https://github.com/NixOS/nixpkgs/commit/c7fd252d324f6eb4eeb9a769d1533cb4ede361ad
      _1password-gui = prev._1password-gui.overrideAttrs (_orig: {
        version = "8.3.0";
        sha256 = "1cakv316ipwyw6s3x4a6qhl0nmg17bxhh08c969gma3svamh1grw";
      });
    };

    nested-master = final: prev: {
      master = inputs.nixpkgs-master.legacyPackages.${prev.system};
    };

    nested-unstable = final: prev: {
      unstable = inputs.unstable.legacyPackages.${prev.system};
    };
  };

  overlays = builtins.foldl' lib.trivial.mergeAttrs { } [
    unstableOverlays
    masterOverlays
    rosettaOverlays
    uniqueOverlays
  ];
in {
  flake = { inherit overlay overlays; };

  perSystem = { lib, system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        config = {
          allowBroken = system == "aarch64-darwin" || system == "x86_64-darwin";
          allowUnfreePredicate = import ../nix/unfree.nix { inherit lib; };
        };
        overlays = [
          inputs.emacs-overlay.overlay
          overlays.nested-master
          overlays.nested-unstable
          overlay
        ] ++ lib.optionals (system == "aarch64-darwin") [
          overlays.rosetta-watchexec
          overlays.rosetta-wrk
        ];
        inherit system;
      };
    in { config = { _module.args.pkgs = pkgs; }; };
}
