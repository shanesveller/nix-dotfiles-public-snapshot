function sorttfvars
	grep -E "^\w+ =" *.tfvars | grep -vE "^(terragrunt|remote_state|aws|tf_)" | sort -c
end
