{ buildRustPackage, fetchCrate, lib }:
let
  pname = "cargo-hack";
  version = "0.5.12";
in buildRustPackage {
  inherit pname version;

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uY5aYLu3IyjghNZbUMQVoaacf+3w23ckTFaTOaw/3Qo=";
  };

  cargoDepsName = pname;
  cargoHash = "sha256-jfSow1LEeE5fTcV9YrZQTknGCNYDCSRw6UGX0Cd8Vmc=";
  doCheck = false;
}
