{ buildRustPackage, fetchCrate }:
let
  pname = "cargo-hack";
  # https://github.com/taiki-e/cargo-hack/releases/latest
  version = "0.5.14";
in buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZfNJivxjZV4PkGBoPqoEEJnOndQLi6v8jOGED0kR0cY=";
  };

  cargoDepsName = pname;
  cargoHash = "sha256-cOq0QAAoVzwh9z4TUvSLE7Z5CCzKZvGd2GZfBwVZ7/A=";
  doCheck = false;
}
