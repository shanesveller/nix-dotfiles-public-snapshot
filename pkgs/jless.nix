{ buildRustPackage, fetchCrate, lib }:
let
  pname = "jless";
  # https://github.com/PaulJuliusMartinez/jless/releases/latest
  version = "0.7.1";
in buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-StuyYZhE+Fws0owjUGbFZqW7iQs/4BVtfVxHftylupE=";
  };

  cargoDepsName = pname;
  cargoHash = "sha256-eU50GJ0AZSnpAYcJ5647+PaywQqsxOO0LSVbhGfeNWs=";
}
