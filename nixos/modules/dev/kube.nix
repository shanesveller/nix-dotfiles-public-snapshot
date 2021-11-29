{ pkgs, ... }: {
  users.users.shane = {
    packages = with pkgs;
      [
        # kubectl
        # minikube
      ];
  };
}
