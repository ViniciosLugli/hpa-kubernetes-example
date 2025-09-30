#!/bin/bash

echo "Real-time Monitoring (Ctrl+C to stop)"
echo ""

watch -n 2 '
echo "=== HPA Status ==="
kubectl get hpa 2>/dev/null
echo ""
echo "=== Pods ==="
kubectl get pods 2>/dev/null
echo ""
echo "=== Pod CPU/Memory ==="
kubectl top pods 2>/dev/null
'