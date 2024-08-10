#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $dockerImageName

# Trivy scan result processing
exit_code=$?
echo "Exit Code: $exit_code"

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
  echo "Container Scanning via Trivy: Vulnerabilities found."
else
  echo "Container Scanning via Trivy: No CRITICAL vulnerabilities found."
fi;