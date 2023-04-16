#! /bin/bash

declare -a resources=("statefulset" "ds" "deployment" "prometheus")
declare -a namespaces=("prometheus")

for namespace in "${namespaces[@]}"; do
for resource in "${resources[@]}"; do
    namespaced_resources=`kubectl get ${resource} -n $namespace | tail -n +2 | cut -d ' ' -f 1`
    for namespaced_resource in $namespaced_resources; do
    kubectl rollout restart $resource $namespaced_resource -n $namespace
    sleep 3
    done
done
done
