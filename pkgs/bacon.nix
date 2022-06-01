{ buildRustPackage, darwin, fetchCrate, lib, stdenv }:
let
  pname = "bacon";
  # https://github.com/Canop/bacon/releases/latest
  # https://github.com/Canop/bacon/releases/tag/v2.1.0
  version = "2.1.0";
in buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8Q6VLpoNFr94J7AT+5owLHU7mhbpMWw90wsnDWJ6QDg=";
  };

  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);

  cargoDepsName = pname;
  cargoHash = "sha256-XkFNKZF9ituUOQeGY7zfJYKmS0zvDhtpOewFih61tD4=";
  doCheck = false;
}
