{ buildRustPackage, darwin, fetchCrate, lib, stdenv }:
let
  pname = "bacon";
  version = "2.0.1";
in buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xTTPPnaCNIZkCZiqdub5Dvszv0xXXfKJhakQF9CuvXg=";
  };

  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);

  cargoDepsName = pname;
  cargoHash = "sha256-kteUhcqGjhBRwKKrDW5Jwt0+t7h/9MdQiTMJ0buPtA4=";
  doCheck = false;
}
