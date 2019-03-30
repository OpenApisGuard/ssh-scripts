
#!/bin/bash
if [ $# -ne 1 ]
  then
  	echo "Scale Kubenetes service pods in a specific namespace based on the config-file (csv format using first column as name of service and second column as number of pods separated by space)"
    echo "Usage: scale-k8s-pods-with-config.sh [namespace] < [config-file]"
    echo "Example: scale-k8s-pods-with-config.sh my-namespace < services.csv"
    echo "config-file: (csv file with two columns using space as delimiter): <service-name> <num-of-pods>"
    printf "config-file example:\nmy-service-1 2\nmy-service-2 3\n"
    exit
fi

echo "Start scaling..."

while IFS= read -r service || [[ -n "$service" ]];
do
	cmd=$(echo $service | awk '{print "kubectl scale --replicas="$2" deployment/"$1" -n"}')
	numOfpods=$(echo $service | awk '{print $2}')
	scale=$($cmd $1)
	echo $scale " to " $numOfpods
done

echo "Completed scaling."