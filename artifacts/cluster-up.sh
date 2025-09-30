#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --config kind-config.yaml --name hpa-demo

echo "Waiting for nodes to be ready..."
kubectl wait --for=condition=ready node --all --timeout=120s

echo "Deploying metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Patching metrics-server for local development..."
kubectl patch deployment metrics-server -n kube-system --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

echo "Waiting for metrics-server to be ready..."
kubectl wait --for=condition=available deployment/metrics-server -n kube-system --timeout=120s

sleep 10

echo "Cluster ready!"
kubectl get nodes
echo ""
echo "Verifying metrics..."
kubectl top nodes