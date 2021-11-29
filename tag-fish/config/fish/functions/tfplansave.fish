function tfplansave --argument filename
    set -l baseName $HOME/Desktop/$filename
    terragrunt plan -out $baseName.plan && terragrunt show -no-color $baseName.plan | tee $baseName.plan.txt
end
