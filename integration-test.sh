#!/bin/bash

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $applicationURL:$PORT/$applicationURI

if [[ | -z "$PORT" ]]; then

  response=$(curl -s $applicationURL:$PORT$applicationURI)
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$PORT$applicationURI)

  if [[ "$response" == 100 ]]; then
    echo "Increment Test passed."
  else
    echo "Increment Test failed."
    exit 1;
  fi;

  if [[ "$http_code" == 200 ]]; then
    echo "HTTP Status Code Test passed."
  else
    echo "HTTP Status Code failed."
    exit 1;    
  fi;

else
  echo "The Service does not have a NodePort"
  exit 1;

fi;
