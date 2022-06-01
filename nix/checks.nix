{ pre-commit, system }:
pre-commit.lib.${system}.run {
  src = ./.;
  hooks = {
    nix-linter.enable = true;
    nix-linter.excludes = [ "flake.nix" ];
    nixfmt.enable = true;
    shellcheck.enable = true;
  };
  settings.nix-linter.checks = [
    # flake.nix: Warns on outputs = inputs@{ ... }
    "AlphabeticalArgs"
    # flake.nix: Warns on seemingly sorted attrsets
    "AlphabeticalBindings"
    "BetaReduction"
    "DIYInherit"
    "EmptyInherit"
    "EmptyLet"
    # flake.nix: Warns on home-manager configurations using { ... }
    "EmptyVariadicParamSet"
    "EtaReduce"
    "FreeLetInFunc"
    "LetInInheritRecset"
    "ListLiteralConcat"
    "NegateAtom"
    "SequentialLet"
    "SetLiteralUpdate"
    "UnfortunateArgName"
    "UnneededAntiquote"
    "UnneededRec"
    # flake.nix: Warns on final/prev mandatory names for overlay arguments
    "UnusedArg"
    "UnusedLetBind"
    "UpdateEmptySet"
  ];
}
