{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs;
      [
        # boot
        # clojure
        # graalvm8
        # gradle
        # gradle_3_5
        # jdk9
        # jdk10
        # jetbrains.idea-ultimate
        # jre8
        # jre10
        # leiningen
        # oraclejdk
        # oraclejdk9
        # oraclejre9
      ];
  };
}
