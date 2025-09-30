#!/bin/bash
set -e

echo "Deleting application resources..."
kubectl delete -f k8s/

echo "Application undeployed!"