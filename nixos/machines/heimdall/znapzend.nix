{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.mbuffer ];

  services.znapzend = {
    enable = true;
    autoCreation = true;
    features.compressed = true;
    features.oracleMode = false;
    features.zfsGetType = true;
    pure = true;
    zetup = {
      "heimdall/home" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/user/home";
        plan = "1h=>15min,1d=>1h,1w=>1d,1m=>1w";
        # destinations = {
        #   yggdrasil = {
        #     dataset = "rpool/znapzend/heimdall-home";
        #     plan = plan + ",1y=>1m,10y=>1y";
        #     host = "root@10.86.0.3";
        #   };
        # };
      };

      "heimdall/local/postgres" = rec {
        enable = true;
        dataset = "rpool/local/postgres";
        mbuffer.enable = true;
        plan = "1d=>1h,1w=>1d,1m=>1w";
        destinations = { };
      };

      "heimdall/root" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/system/root";
        plan = "1d=>3h,1w=>1d,1m=>1w";
        # destinations = {
        #   yggdrasil = {
        #     dataset = "rpool/znapzend/heimdall-root";
        #     plan = plan + ",1y=>1m,10y=>1y";
        #     host = "root@10.86.0.3";
        #   };
        # };
      };

      "heimdall/user/dropbox" = rec {
        enable = true;
        dataset = "rpool/user/dropbox";
        mbuffer.enable = true;
        plan = "1d=>3h,1w=>1d,1m=>1w";
        destinations = { };
      };

      "heimdall/var" = rec {
        enable = true;
        recursive = true;
        mbuffer.enable = true;
        dataset = "rpool/system/var";
        plan = "1d=>1h,1w=>1d,1m=>1w";
        # destinations = {
        #   yggdrasil = {
        #     dataset = "rpool/znapzend/heimdall-var";
        #     plan = plan + ",1y=>1m,10y=>1y";
        #     host = "root@10.86.0.3";
        #   };
        # };
      };
    };
  };

}
