
#!/bin/bash
if [ $# -ne 2 ]
  then
    echo "Scale all Kubenetes service pods with specific count in a desired namespace"
    echo "Usage: scale-k8s-pods [namespace] [scale-count]"
    echo "Example: scale-k8s-pods my-namespace 0"
    exit
fi

deploys=$(kubectl get deployments -n $1 -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo "Started scaling deployments to " $2 "....."
for i in $deploys
do 
   deploymentScaled=$(kubectl scale --replicas=$2 deployment/"$i" -n $1)
   echo $deploymentScaled " to " $2
done
echo "Completed scaling."
