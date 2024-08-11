#!/bin/bash

total_fail=$(kube-bench run --targets node --version 1.15 --check 2.1.2,2.1.3 --json | jq .[].total_fail)

if [[ "$total_fail" -ne 0 ]]; then
  echo "CIS Benchmark Failed for Node while testing 2.1.1 and 2.1.2"
  exit 1;
else
  echo "CIS Benchmark Passed for Node while testing 2.1.1 and 2.1.2"
fi;