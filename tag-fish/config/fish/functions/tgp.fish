function tgp -w terragrunt
    terragrunt plan -out terraform.plan -input=false $argv
end
