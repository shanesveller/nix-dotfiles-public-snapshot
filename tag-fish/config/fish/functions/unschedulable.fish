function unschedulable --description='Lists unschedulable pods' --wraps=kubectl
    kubectl get pods --all-namespaces --field-selector='status.phase!=Running' -o json | \
        jq '.items[] | select(.status.conditions[].reason == "Unschedulable") | {"name": .metadata.name, "namespace": .metadata.namespace}'
end
