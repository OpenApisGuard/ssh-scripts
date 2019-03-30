#!/bin/bash
if [ $# -ne 2 ]
  then
    echo "Capturing Kubenetes service pods log files and restarting all service pods in a specific namespace"
    echo "Usage: restart-k8s-service-pods.sh [namespace] [service-label]"
    echo "Example: restart-k8s-service-pods.sh my-namespace my-service"
    exit
fi

ns=$1
label=$2

pods=$(kubectl -n $ns get po -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -l service=$label)

for p in $pods;
do
  echo -e "\n--- Getting log from pod: " $p "\n---"
  kubectl -n $ns logs $p > $p.log
done

echo -e "\n--- Stopping pods labeled with: " $label "\n---"
kubectl -n $ns delete pods -l service=$label
