self: final: prev: {
  inherit (self.outputs.packages.${prev.system})
    bacon cargo-hack cargo-nextest jless;
  zellijNext = self.outputs.packages.${prev.system}.zellij;
}
