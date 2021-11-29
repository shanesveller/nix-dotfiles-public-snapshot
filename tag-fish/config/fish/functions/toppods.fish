function toppods -w kubectl
	kubectl top pods --all-namespaces $argv | sort -k1,2
end
