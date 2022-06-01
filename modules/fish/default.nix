{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.fish;
in {
  options.programs.shanesveller.fish = {
    enable = mkEnableOption "Fish Shell";
    omf = mkEnableOption "OhMyFish plugins";

    # TODO: conditional initialization
    # TODO: option for overlay, or extract overlay
    starship = mkEnableOption "Starship prompt";

    username = mkOption {
      type = types.str;
      default = "shane";
      defaultText = "shane";
      example = literalExample "shanesveller";
      description = "The local default username.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = if (pkgs ? fishPlugins) then
      [ pkgs.fishPlugins.foreign-env ]
    else
      [ pkgs.fish-foreign-env ];

    # TODO: Overlay
    # nixpkgs.overlays =
    #   mkIf cfg.starship [ (self: super: { starship = unstable.starship; }) ];

    programs.direnv.enable = true;
    programs.direnv.enableFishIntegration = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.nix-direnv.enableFlakes = true;

    programs.fish = {
      enable = true;

      functions = {
        cdtemp = "cd (mktemp -d)";
        dguard = {
          argumentNames = "imageTag";
          body =
            "ls Docker* .docker* docker-compose.yml | ${pkgs.entr}/bin/entr -cd docker build -t $imageTag .";
        };
        dockercontext =
          "rg --no-ignore --no-ignore-global --ignore-file .dockerignore --files";
        dockerkit = {
          body = "env DOCKERBUILD_KIT=1 docker $argv";
          wraps = "docker";
        };
        ed = ''
          eval cd (emacsclient -e "(with-current-buffer (car (buffer-list)) (expand-file-name default-directory))")'';
        emorg = {
          argumentNames = "orgFilename";
          body = "et ~/Dropbox/org/$orgFilename.org";
        };
        emorgp = {
          argumentNames = "orgFilename";
          body = "et ~/Dropbox/org/$orgFilename.org.gpg";
        };
        erldident = {
          argumentNames = "imageName";
          body = ''
            docker inspect --format='{{index .RepoDigests 0}}' $imageName
            docker run -it --rm $imageName sh -c "elixir -v"
            docker run -it --rm $imageName sh -c "erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"
            docker run -it --rm $imageName sh -c "cat /etc/issue"
          '';
        };
        erlversion = ''
          erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().' -noshell'';
        exguard = ''
          set -q TEST_DATABASE_URL; and set -x DATABASE_URL $TEST_DATABASE_URL
          ${pkgs.watchexec}/bin/watchexec -c -e 'ex,exs,lock,eex' -- mix $argv
        '';
        gcloudcontext =
          "${pkgs.ripgrep}/bin/rg --no-ignore --no-ignore-global --ignore-file .gcloudignore --files";
        hexdoc = "command mix hex.docs open $argv";
        hsearch = {
          argumentNames = "query";
          body = "helm search repo --versions $query";
        };
        imdp = "iex -S mix do deps.get, phx.server";
        imix = "iex -S mix $argv";
        kca = {
          body = "kubectl $argv --all-namespaces";
          wraps = "${pkgs.kubectl}/bin/kubectl";
        };
        kcdf = {
          body =
            "${pkgs.kubectl}/bin/kubectl drain --force --delete-local-data --ignore-daemonsets $argv";
          wraps = "${pkgs.kubectl}/bin/kubectl";
        };
        kcs = {
          body = "kubectl -n kube-system $argv";
          wraps = "${pkgs.kubectl}/bin/kubectl";
        };
        knsscale = {
          argumentNames = [ "namespace" "replicas" ];
          body =
            "kubectl get deploy -n $namespace -o jsonpath='{.items[*].metadata.name}' | xargs kubectl scale deploy -n $namespace --replicas $replicas";
          wraps = "${pkgs.kubectl}/bin/kubectl";
        };
        read_config = ''
          while true
            read -p 'echo "Confirm? (y/n):"' -l confirm

            switch $confirm
              case Y y
                return 0
              case \'\' N n
                return 1
            end
          end
        '';
        pltfind = {
          body = ''
            set -l currentElixir (asdf current elixir | cut -d '-' -f 1)
            set -l currentErlang (asdf current erlang | cut -d ' ' -f 1)
            find _build -type f -name 'dialyxir*.plt*' ! -name "*$currentErlang*$currentElixir*" $argv
          '';
          wraps = "find";
        };
        pmix = "env MIX_ENV=prod mix $argv";
        psts = {
          body = "pstree -s $argv";
          wraps = "pstree";
        };
        sternr = "command stern --since=5m $argv";
        sterns = "command stern -n kube-system $argv";
        tmix = ''
          set -q TEST_DATABASE_URL; and set -x DATABASE_URL $TEST_DATABASE_URL
          env MIX_ENV=test mix $argv
        '';
        toppods = {
          body = "kubectl top pods --all-namespaces $argv | sort -k1,2";
          wraps = "${pkgs.kubectl}/bin/kubectl";
        };
        tpl = {
          body = "tmuxp load $argv";
          wraps = "tmuxp";
        };
        unschedulable = {
          body = ''
            kubectl get pods \
              --all-namespaces \
              --field-selector='status.phase!=Running' \
              -o json | \
                jq '.items[] | select(.status.conditions[].reason == "Unschedulable") | {"name": .metadata.name, "namespace": .metadata.namespace}'
          '';
          description = "Lists unschedulable pods";
          wraps = "kubectl";
        };
        wdig = {
          argumentNames = "domainName";
          body = "watch -d -n15 dig +short $domainName";
        };
        wkc = ''watch -dn5 "kubectl $argv"'';
      };

      interactiveShellInit = mkMerge [
        ''
          function __add_path_if_exists -a target_path
            test -d $target_path; and set -g --append fish_user_paths $target_path
          end

          function __source_file_if_exists -a target_file
            test -f $target_file; and source $target_file
          end

          __source_file_if_exists $HOME/.asdf/asdf.fish
          __source_file_if_exists /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

          __add_path_if_exists $HOME/.cargo/bin
          __add_path_if_exists /usr/local/opt/gnu-getopt/bin
          __add_path_if_exists /usr/local/opt/postgresql@10/bin

          functions -e __add_path_if_exists
          functions -e __source_file_if_exists
        ''

        (mkIf (config.programs.shanesveller.emacs.enable
          && config.programs.shanesveller.emacs.doom) ''
            set -g --append PATH ${config.xdg.configHome}/emacs/bin
          '')

        (mkIf (cfg.omf) ''
          set -g default_user ${cfg.username}
          set -g fish_greeting ""
          set -g fish_key_bindings fish_default_key_bindings
          set -g fish_prompt_pwd_dir_length 2
        '')

        (mkIf pkgs.stdenv.isDarwin ''
          /usr/bin/ssh-add -l | grep "The agent has no identities." >/dev/null; and /usr/bin/ssh-add -A >/dev/null
        '')
      ];

      plugins = mkIf cfg.omf [{
        name = "emacs";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-emacs";
          rev = "21297223af8d567387527daa050f426a9bf6265d";
          sha256 = "05jg2lvyixb68c3qy6zjny0ai78gv0dpdym9r8j4jv5qvq9a1jfr";
          # date = 2019-05-24T13:30:32-05:00;
        };
      }];

      # https://github.com/oh-my-fish/theme-bobthefish#configuration
      shellInit = ''
        set -g --prepend fish_user_paths $HOME/.nix-profile/bin
      '';

      shellAbbrs = {
        brewdated =
          mkIf (pkgs.stdenv.isDarwin) "brew update; and brew outdated";
        fig = "docker-compose";
        hm = "home-manager";
        hmc = "nvim $HOME/.config/nixpkgs/home.nix";
        hmcp = "nvim $HOME/.config/nixpkgs/hm/";
        hmvb = "home-manager -nv build";
        hmvs = "home-manager --keep-going --verbose switch";
        kc = "kubectl";
        mk = "minikube";
        pbcopy = mkIf (pkgs.stdenv.isLinux) "xclip -selection 'clipboard'";
      };
    };

    programs.starship = {
      enable = cfg.starship;
      settings = {
        directory = {
          fish_style_pwd_dir_length = 2;
          truncate_to_repo = false;
          truncation_length = 2;
        };
        gcloud = { disabled = true; };
        kubernetes = { disabled = !config.programs.shanesveller.kube.enable; };
      };
    };

    programs.zoxide.enableFishIntegration = true;
  };
}
