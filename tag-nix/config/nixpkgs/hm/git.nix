{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.git;

  commit-templates = {
    conventional = pkgs.writeText "gitmessage-conventional" ''

      # <type>(<scope>): <subject>
      # types: feat, fix, docs, style, refactor, test, chore
      # scope: arbitrary by project
      # subject: imperative tense, no capital, no period
      #
      # body: imperative tense, include motivation for the change and contrasts with previous behavior
      #
      # footer: BREAKING CHANGE, issue references (closes #12345)
      # https://github.com/clog-tool/clog-cli/tree/bd3e45fdc8674e5f9a03a5136760dff0657817d6#about
      # https://github.com/conventional-changelog/conventional-changelog/blob/a5505865ff3dd710cf757f50530e73ef0ca641da/conventions/angular.md
    '';

    dotfiles = pkgs.writeText "gitmessage-dotfiles" ''

      # categories: "", security, break, feature, fix, add, remove, deprecate
      # scopes: "", asdf, brew, doc, emacs, homemanager, nix
    '';
  };

  configIncludes = {
    conventionalCommits = {
      commit = { template = commit-templates.conventional.outPath; };
    };

    dotfiles = { commit = { template = commit-templates.dotfiles.outPath; }; };
  };

  workConfig = {
    core = { excludesfile = "~/.config/git/ignore.work"; };
    remote = { pushDefault = "origin"; };
    user = { email = "shane@sveller.dev"; };
  };

in {
  options.programs.shanesveller.git = {
    enable = mkEnableOption "Git";
    work = mkEnableOption "Work-specific git config";

    # https://github.com/rycee/home-manager/blob/33c6230dac5589dfd2e043463061a13c82c20794/modules/programs/git.nix#L129-L134
    workIgnores = mkOption {
      type = types.listOf types.str;
      default = [ ];
      defaultText = "[]";
      example = [ "*.nix" ];
      description =
        "List of file masks to include in work-specific gitignores.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs;
        [
          clog-cli
          # (python37.withPackages (ps: with ps; [ virtualenv ]))
        ] ++ (with pkgs.gitAndTools; [
          git-absorb
          gitflow
          git-filter-repo
          git-revise
          git-trim
          gh
          hub
          pre-commit
        ]);

      programs.git = {
        enable = true;
        userName = "Shane Sveller";
        userEmail = "shanesveller@gmail.com";

        signing = {
          key =
            "F83C407CADC45A0F1F2F44E89210C218023C15CD"; # shane@shanesveller.com
          signByDefault = true;
        };

        includes = [
          {
            path = "${config.xdg.configHome}/git/config.dotfiles";
            condition = "gitdir:~/.dotfiles/";
          }
          {
            path = "${config.xdg.configHome}/git/config.conventional";
            condition = "gitdir:~/src/side-projects/";
          }
        ];

        ignores =
          [ ".DS_Store" ".direnv" ".elixir_ls" ".tool-versions" "TODOS.org" ];

        aliases = {
          bclean =
            "!git branch --merged master | grep -v '\\\\* master' | xargs -n 1 git branch -d";
          bp = "browse -- pulls";
          diff-rebase = "range-diff @{u} @{1} @";
          fclean =
            "!git checkout develop && git pull origin develop && git branch --merged develop --list 'feature/*' --format='%(refname:short)' | xargs -n 1 git branch -d";
          plog = "log --all --graph --decorate --oneline --abbrev-commit";
          pr-changelog =
            ''log --pretty="format: - [X] %s" --reverse origin/master..'';
          prune-all = "!git remote | xargs -n 1 git remote prune";
          pullclean =
            "!git checkout master && git pull origin master && git branch --merged master | grep -v '\\\\* master' | xargs -n 1 git branch -d";
          remotes = "remote -v";
          tags = "tag -l";
          thisweek = ''
            log --pretty="%ad - %s" --date=short --author='Shane Sveller' --since=1.weeks --all --no-merges'';
          today = ''
            log --pretty="%s." --author='Shane Sveller' --since=midnight --all --no-merges'';
          yesterday = ''
            log --pretty="%s." --author='Shane Sveller' --since=3.days --until=yesterday --all --no-merges'';
        };

        extraConfig = {
          credential.helper = "osxkeychain";
          diff.compactionHeuristic = true;
          "diff \"sopsdiffer\"".textconf = "sops -d";
          difftool.prompt = false;
          github.user = "shanesveller";
          "gitlab \"sveller.codes/api/v4\"".user = "shane";
          init.defaultBranch = "main";
          magit.hideCampaign = true;
          magithub.online = false;

          "magithub \"status\"" = {
            includeStatusHeader = false;
            includePullRequestsSection = false;
            includeIssuesSection = false;
          };

          push.default = "simple";
          status.short = 1;
          tag.gpgsign = true;
          web.browser = "open";

          url = {
            "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
          };
        };
      };

      xdg.configFile = {
        "git/config.conventional".text =
          generators.toINI { } configIncludes.conventionalCommits;
        "git/config.dotfiles".text =
          generators.toINI { } configIncludes.dotfiles;
      };
    }

    (mkIf (cfg.work) {
      programs.git.includes = [{
        path = "~/.config/git/config.work";
        condition = "gitdir:~/src/fastradius/";
      }];
      xdg.configFile = {
        "git/config.work".text = generators.toINI { } workConfig;

        # https://github.com/rycee/home-manager/blob/33c6230dac5589dfd2e043463061a13c82c20794/modules/programs/git.nix#L180-L182
        "git/ignore.work" = mkIf (cfg.workIgnores != [ ]) {
          text = concatStringsSep "\n" cfg.workIgnores + "\n";
        };
      };
    })
  ]);
}
