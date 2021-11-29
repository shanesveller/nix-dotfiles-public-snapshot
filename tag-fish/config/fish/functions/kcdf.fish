function kcdf -w kubectl
    kubectl drain --force --delete-local-data --ignore-daemonsets $argv
end
