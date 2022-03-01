{ buildRustPackage, fetchCrate, lib }:
let
  pname = "cargo-nextest";
  version = "0.9.8";
in buildRustPackage {
  inherit pname version;

  # https://crates.io/crates/cargo-nextest
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jLJ/h97k2UexXKoaFfvzQGnyLLODfZ676E62+9J/gk4=";
  };

  cargoDepsName = pname;
  cargoHash = "sha256-pYUuMiXWJ6cqqilh+RtUEbpNc6Qbt78XxriV2wy6uvg=";
}
