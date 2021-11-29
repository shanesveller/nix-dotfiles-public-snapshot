function wdig --argument domainName
    watch -d -n15 dig +short $domainName
end
