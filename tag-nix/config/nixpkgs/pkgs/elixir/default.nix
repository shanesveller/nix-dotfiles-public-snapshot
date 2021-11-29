{ pkgs, wxSupport ? true }:

let
  inherit (builtins)
    compareVersions concatStringsSep elemAt getAttr head replaceStrings sort
    splitVersion;

  inherit (pkgs.stdenv.lib.attrsets) mapAttrs mapAttrs' nameValuePair;

  # https://github.com/erlang/otp/releases
  # https://github.com/NixOS/nixpkgs/blob/446c97f96f956131036aa98b8ecf275c0d78ac2b/pkgs/development/interpreters/erlang/R24.nix
  # nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-23.1.5.tar.gz
  erl_versions_and_checksums = {
    # "20.1"   = "13f53lzgq2himg9kax41f66rzv5pjfrb1ln8b54yv9spkqx2hqqi";
    # "20.2"   = "1csy3wbbm5qp6ih2hcdj5nzy97smmpbm0nlvqm3w0db784aj2w0j";
    # "20.2.4" = "1j8fqzaw36j8naafrrq1s329jlvlb06ra1f03hl76xr0bbxm44ks";
    # "20.3"   = "0xixqlymkk05pwvifmqn3sv2lhmrrvplnqp69d6gzwpp64dh7qir";
    # "21.0.3" = "0rqr1i5n8qm2mkkivc5ja2kzfpvxh2cg94fr0yc0id1f790m6dkq";
    # "21.1"   = "0a31kn6h2qgdzdy3247f7x6j0cywzzf1938h82jc3sq571h5i9wf";
    # "21.2.2" = "0i6i928waijn23cng4d3ba1k1kx3kc18pwp397nyfbxd4cncgdn7";
    "21.2.3" = "1v47c7bddbp31y6f8yzdjyvgcx9sskxql33k7cs0p5fmr05hhxws";
    # "21.2.5" = "0c7bi8daqylqlflaiwcrqzmhvi2yzganq4djlykl6r17i4zal95q";
    # "21.2.6" = "0vb5yr4b1py9p5c9al1zkhavrwwc9hj5d66ly01v8kxrqlkzxqls";
    # "21.2.7" = "0zcai3550iz3rii9z50svs6ck8h3ijlz66y5rrqz2hmzq2bl4cvp";
    # "21.3"   = "0gpzyyqnp3p5z6kif90rr5gflwb571abr0564hjx8a0159g1win3";
    # "21.3.5" = "06wbl5hsjjg17316nbjdrvad44jj7f8zxg5ah3xxcdbm3xx19c2x";
    "21.3.8.8" = "0kxjdccciz7s0138cy06zaaln6d39nn0fh59k5bblkl1pgdhwzs2";
    "22.0" = "0gsmgpcqapp0lrwm8aazzy2w4yg5ygsjvvcfpkwz39xfhp776k55";
    "22.0.4" = "1aqkhd6nwdn4xp5yz02zbymd4x8ij8fjw9ji8kh860n1a513k9ai";
    "22.0.7" = "1jk78b674cvi6fh6fj5jqqnqv4452x9bn6h79yrdm5nws1nh84am";
    "22.1" = "0p0lwajq5skbhrx1nw8ncphj409rl6wghjrgk7d3libz12hnwrpn";
    "22.1.1" = "01488f09if8l26qznwcsvfg9f7pmhs12swhvwwi8zw2q8j9yngyk";
    "22.1.2" = "1fz8qvsxfm5plh2hrfh510jwwkfd5pfbwm66ixri79ni7cfrfxdw";
    "22.1.3" = "02n7x208frbym63m1lpm3hscq6464gbmzqmf910m6fjpsyrxm8s2";
    "22.1.4" = "1n9pf1zxnl5dmv4xihgw7x8a1a4s1wfygr54rzsqw0bjjc86r7ym";
    "22.1.5" = "01md2z4qqaycq683fdy5alhyls03k8n3663x1iwji4w9y2yyk1qv";
    "22.1.6" = "00chnk9xzx1i1scbzcxlz6c4cl5i2b54fgdj14fbygyqg0ps7hr4";
    "22.1.7" = "18aqy2s8nqd82v4lzzxknrwjva8mv1y2hvai9cakz5nkyd3vwq62";
    "22.1.8" = "17x9c5nl0jda5c5a8k84z7r4pv25x6i2j91nld8mz0shg1zvssxq";
    "22.2" = "1s56sqzg0ijiff0pfnnp6walmy3jbpqhz0crv3fpmjfs1m5kjhw6";
    "22.2.1" = "070l0c40jwaq2s19mklq7459a0gd9v81q29xga39rbkv6diqcdq0";
    "22.2.2" = "1jm2hxsc7wbs8yy69xzrsl6whgq7hs3gj9ayvxlw35abzakvxx0g";
    "22.2.6" = "0vvia0xl2j841zny90f3jyjhgvkv7cnrxwj553m16vxz7rvfsfh5";
    "22.2.8" = "08zswjfrc4nbvj74p95cijxp5sz28bp0dwy62yh30dbz165hd140";
    "22.3" = "0srbyncgnr1kp0rrviq14ia3h795b3gk0iws5ishv6rphcq1rs27";
    "22.3.1" = "0lywf4qkhzryc6j9xvklivm8hm9rgnr0ahqp4809qaspappi43kq";
    "22.3.2" = "1djn1xb8iy36b1zzca5ap4wbl293w67c1i6d5syrf73lxs5dg450";
    "22.3.3" = "17rwdnqs72vimzh2ka7hzcwl1kfaiypc5kpmf5w2s7acfm8vg4m1";
    "22.3.4.1" = "1mbz1skrs3l1kvqa3gwsdrjfr0mh9kmkql2n4z2al2qrg5m4ajkj";
    "22.3.4.2" = "0xkax557qaznac5ad2r8kwlqv0ly4d770vifnl8w99a2p50la02r";
    "22.3.4.4" = "0qchcj65qf2z941jm2qf97p9l7razm2y3kp4z1a4qbrwvn2b7fgd";
    "23.0" = "0hw0js0man58m5mdrzrig5q1agifp92wxphnbxk1qxxbl6ccs6ls";
    "23.0.1" = "1y5ag7k3zydxk3zicxh1frbmi4qda8a7qqcal5k2hdlj671zapzw";
    "23.0.2" = "19ly2m0rjay6071r75s9870cm3sph25zd1mvy67l5v4jg7mxdjzy";
    "23.1.1" = "0l4mpmi1wkggsr99l1fh8xqnx823xbp1fx4n9xpbxkz4baziyi7p";
    "23.1.2" = "06dp2sw486khy2lc34cw5dca58ii5jvi26dpchiqxnmyvd6995z0";
    "23.1.5" = "0pxf8h6dd1a1i7vlklc5jqbb6ab91axnldgg3vmvgff6a554xd7x";
    "23.2.3" = "0k29ns2g1m04bdf31sn33h7yydcy00lpyha1pnj364rjg4m2jm2p";
    "23.2.5" = "1vhxxsxzkqazi1dwpzbhkwy6adccf24yvzm50hs7p0rbv99mprjn";
    "23.2.7.2" = "1lnpn1ipl78pzn0z2xz2ngijc5qsrf6fbdk56rwchniwdzg8izhy";
    "23.3.2" = "1z4vy3vhb8rdr26z2zhhyhsi4jnxq63h0bk92qvwibba2acc2kbr";
    "23.3.4" = "11hi7w1m73mip7svzph6vcbf58rdircwamb1k8wby6mmqb0v19qh";
    "24.0" = "0p4p920ncsvls9q3czdc7wz2p7m15bi3nr4306hqddnxz1kxcm4w";
  };

  # https://github.com/elixir-lang/elixir/releases
  # https://github.com/NixOS/nixpkgs/blob/a4a35cdb0de5b278499df95fe827903ebf707a64/pkgs/development/interpreters/elixir/1.11.nix
  # nix-prefetch-url --unpack https://github.com/elixir-lang/elixir/archive/v1.10.2.tar.gz
  elixir_versions_and_checksums = {
    # "1.6.0" = "0wfmbrq70n85mx17kl9h2k0xzgnhncz3xygjx9cbvpmiwwdzgrdx";
    # "1.6.1" = "01q5nxpgbpkiw9wk7na6arxc5s75sc3qh8gw8xwnrgxg9iabkqcf";
    # "1.6.5" = "0il1fraz6c8qbqv4wrp16jqrkf3xglfa9f3sdm6q4vv8kjf3lxxb";
    # "1.6.6" = "1wl8rfpw0dxacq4f7xf6wjr8v2ww5691d0cfw9pzw7phd19vazgl";
    "1.7.0" = "082924fngc6ypbkn1ghdwf199radk00daf4q09mm04h81jy4nmxm";
    "1.7.1" = "0y9wkwkr9pbkrfm9z4sjv8a2cqvgjb7qbsqpyal0kz232npy0pxs";
    "1.7.2" = "0wnrx6wlpmr23ypm8za0c4dl952nj4rjylcsdzz0xrma92ylrqfq";
    "1.7.3" = "0d7rj4khmvy76z12njzwzknm1j9rhjadgj9k1chjd4gnjffkb1aa";
    "1.7.4" = "0f8j4pib13kffiihagdwl3xqs3a1ak19qz3z8fpyfxn9dnjiinla";
    "1.8.0" = "156md90qzg0ghj5vck09hzhjks0m8jahcbgrrrgk7i7qcmad8x2k";
    "1.8.1" = "1npnrkn21kqqfqrsn06mr78jxs6n5l8c935jpxvnmj7iysp50pf9";
    "1.8.2" = "1n77cpcl2b773gmj3m9s24akvj9gph9byqbmj2pvlsmby4aqwckq";
    "1.9.0" = "0yfqh07wjgm10v6acn5pw8l8jndjly5kpzgw4harlj81wcaymlsw";
    "1.9.1" = "106s2a3dykc5iwfrd5icqd737yfzaz1dw4x5v1j5z2fvf46h96dx";
    "1.9.2" = "19yn6nx6r627f5zbyc7ckgr96d6b45sgwx95n2gp2imqwqvpj8wc";
    "1.9.3" = "0h4jl1aihqi8lg08swllj0zw4liskf0daz615c7sbs63r48pp28h";
    "1.9.4" = "1l4318g35y4h0vi2w07ayc3jizw1xc3s7hdb47w6j3iw33y06g6b";
    "1.10.1" = "07iccn90yp11ms58mwkwd9ixd9vma0025l9zm6l7y0jjzrj3vycy";
    "1.10.2" = "04yi1hljq7ii9flh6pmb5411z7q1bdq9f9sq8323k9hm1f5jwkx6";
    "1.10.3" = "18bqqqzvhr1zj491wc3d36a310mg1wcs12npp70zfmgqrc60q65a";
    "1.10.4" = "16j4rmm3ix088fvxhvyjqf1hnfg7wiwa87gml3b2mrwirdycbinv";
    "1.11.1" = "0czyv98sq9drlvdwv3gw9vnhn8qa3va4xh5vdqpg7m6b93l1r3p1";
    "1.11.2" = "0b4nfgxhmi4gwba9h9k103zrkpbxxvk0gmdl0ggrd5xlg6v288ky";
    "1.11.3" = "0ivah4117z75pinvb3gr22d05ihfwcdgw5zvvpv7kbgiqaj8ma8f";
    "1.11.4" = "1y8fbhli29agf84ja0fwz6gf22a46738b50nwy26yvcl2n2zl9d8";
    "1.12.0" = "0nx0ajbpib0hxpxz33p1kr3rqgvf35vkx91sh427qcjqy7964z16";
  };

  slugifier = replaceStrings [ "." "-" ] [ "_" "_" ];

  majorVersion = version: elemAt (splitVersion version) 0;

  erl_package_for_version = version: sha256:
    let
      erlangPackageSet =
        getAttr ("erlangR" + (majorVersion version)) pkgs.beam.packages;
      name = ("erlang_" + (slugifier version));
      value = erlangPackageSet.erlang.override {
        inherit sha256 version wxSupport;
        installTargets = "install";
      };
    in nameValuePair name value;

  elixir_package_for_version = version: sha256: erlang:
    let
      name = concatStringsSep "_" [ "elixir" (slugifier version) ];
      value = (pkgs.beam.packagesWith erlang).elixir.override {
        inherit sha256 version;
      };
    in nameValuePair name value;

  erl_set_mapper = version: checksum:
    let
      erl_package = erl_package_for_version version checksum;
      base_packageset = { erlang = erl_package.value; };
      elixir_mapper = version: checksum:
        elixir_package_for_version version checksum erl_package.value;
      elixir_packages = mapAttrs' elixir_mapper elixir_versions_and_checksums;
      extra_packages = {
        inherit (pkgs.beam.packagesWith erl_package.value) hex rebar rebar3;
      };
      name = erl_package.name;
      value = (base_packageset // elixir_packages // extra_packages);
    in nameValuePair name value;

  recursive = mapAttrs' erl_set_mapper erl_versions_and_checksums;
in recursive
