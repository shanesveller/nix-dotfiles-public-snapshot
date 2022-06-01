{ buildRustPackage, fetchCrate }:
let
  pname = "cargo-nextest";
  # https://github.com/nextest-rs/nextest/releases
  version = "0.9.14";
in buildRustPackage {
  inherit pname version;

  # https://crates.io/crates/cargo-nextest
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-d8xKTMm59On6mlfEKSCpviciPOjsz/TK57f7nfSFpHQ=";
  };

  doCheck = false;

  cargoDepsName = pname;
  cargoHash = "sha256-Hm15sQ4eiNa7y8zNTgxWF2rLCqiQWzHTom74rH6Gp0s=";
}
