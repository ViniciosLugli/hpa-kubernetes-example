#!/bin/bash
set -e

echo "Building Docker image..."
docker build -t php-apache:local app/

echo "Loading image into kind cluster..."
kind load docker-image php-apache:local --name hpa-demo

echo "Deploying application..."
kubectl apply -f k8s/

echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available deployment/php-apache --timeout=120s

echo "Application deployed!"
kubectl get pods
kubectl get svc
echo ""
echo "HPA Status:"
kubectl get hpa