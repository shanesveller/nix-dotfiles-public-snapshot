function kcngp --argument namespace
	kubectl get po -n $namespace -w
end
