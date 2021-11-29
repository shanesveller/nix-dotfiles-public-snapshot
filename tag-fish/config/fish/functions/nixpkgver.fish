function nixpkgver
	nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'
end
