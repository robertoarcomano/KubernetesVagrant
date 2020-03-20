#!/usr/bin/env bats
@test "Test Suite for Kubernetes" {
  # 0. Set timeout to 5 seconds
  TIMEOUT=5

  # 1. Retrieve port number
  PORT=$(kubectl get service|grep nginx|awk '{print $5}'|awk -F':' '{print $2}'|awk -F'/' '{print $1}')

  # 2. Get Actual Nodes
  NODES=$(kubectl get pods|grep nginx|awk '{print $1}'|while read pod; do kubectl describe pod $pod|grep Node:|awk '{print $2}'|awk -F'/' '{print $1}'; done|sort -u)

  # 3. Test with curl
  for node in $NODES; do
    RESULT=$(timeout $TIMEOUT curl $node:$PORT 2>/dev/null|grep -c "<h1>Welcome to nginx")
    [ "$RESULT" -eq 1 ]
  done
}
