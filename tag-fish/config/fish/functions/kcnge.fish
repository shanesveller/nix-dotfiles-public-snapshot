function kcnge --argument namespace
	kubectl get ev -n $namespace -w
end
