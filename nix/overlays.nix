self:
let
  lib = self.inputs.nixpkgs.lib;
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

  unstablePackages = [
    "datagrip"
    "nix-direnv"
    "polybar"
    "rust-analyzer"
    "tailscale"
    "thunderbird"
  ];
  masterPackages = [ "discord" ];

  masterOverlays = builtins.listToAttrs (builtins.map
    (name: lib.attrsets.nameValuePair "master-${name}" (fromMasterIfNewer name))
    masterPackages);

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

    my-zellij = final: prev: {
      zellij = chooseNewer prev.unstable.zellij
        (chooseNewer prev.zellijNext prev.zellij);
    };

    nested-master = final: prev: { master = self.pkgs.${prev.system}.master; };

    nested-unstable = final: prev: {
      unstable = self.pkgs.${prev.system}.unstable;
    };
  };
in builtins.foldl' lib.trivial.mergeAttrs { } [
  unstableOverlays
  masterOverlays
  uniqueOverlays
]
