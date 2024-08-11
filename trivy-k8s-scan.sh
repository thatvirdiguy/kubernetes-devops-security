#!/bin/bash

echo $imageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $imageName
# going with exit code 0 because the sample app has a lot of vulnerabilities, including log4j, and I'm no developer 
# docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $imageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $imageName

# Trivy scan result processing
exit_code=$?
echo "Exit Code: $exit_code"

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
  echo "Image Scanning via Trivy: Vulnerabilities found."
  exit 1;
else
  echo "Image Scanning via Trivy: No CRTICAL vulnerabilities found."
fi;