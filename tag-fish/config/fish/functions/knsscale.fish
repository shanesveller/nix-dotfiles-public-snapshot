function knsscale -w kubectl --argument namespace replicas
    kubectl get deploy -n $namespace -o jsonpath='{.items[*].metadata.name}' | xargs kubectl scale deploy -n $namespace --replicas $replicas
end
