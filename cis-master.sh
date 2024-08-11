#!/bin/bash

total_fail=$(kube-bench master --version 1.15 --check 1.1.2,1.1.3,1.1.4 --json | jq .[].total_fail)

if [[ "$total_fail" -ne 0 ]]; then
  echo "CIS Benchmark Failed for Node while testing 1.1.1, 1.1.2, and 1.1.3"
  exit 1;
else
  echo "CIS Benchmark Passed for Node while testing 1.1.1, 1.1.2, and 1.1.3"
fi;