{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ mbuffer ];

  services.znapzend = {
    enable = true;
    autoCreation = true;
    pure = true;
    zetup = {
      "yggdrasil/data" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/legacy/data";
        plan = "1h=>15min,1d=>1h,1w=>1d,1m=>1w";
      };

      "yggdrasil/home" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/user/home";
        plan = "1h=>15min,1d=>1h,1w=>1d,1m=>1w";
      };

      "yggdrasil/root" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/system/root";
        plan = "1h=>15min,1d=>1h,1w=>1d,1m=>1w";
      };

      "yggdrasil/var" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/system/var";
        plan = "1h=>15min,1d=>1h,1w=>1d,1m=>1w";
      };
    };
  };

}
