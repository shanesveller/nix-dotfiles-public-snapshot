function dockerkit -w docker
    env DOCKERBUILD_KIT=1 docker $argv
end
