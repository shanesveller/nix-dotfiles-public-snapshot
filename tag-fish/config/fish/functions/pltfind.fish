function pltfind -w find
    set -l currentElixir (asdf current elixir | cut -d '-' -f 1)
    set -l currentErlang (asdf current erlang | cut -d ' ' -f 1)
    find _build -type f -name 'dialyxir*.plt*' ! -name "*$currentErlang*$currentElixir*" $argv
end
