#!/bin/sh

set -e

echo 'Starting producer deployment...'
K8S_BASE_DIR=../../k8s

pushd $K8S_BASE_DIR

echo 'Deploying HPA based producer'
kubectl apply -f hpa/deployment.yaml
kubectl apply -f hpa/hpa.yaml

echo 'Deploying KEDA based producer'
kubectl apply -f keda/deployment.yaml
kubectl apply -f keda/triggerAuthentication.yaml
kubectl apply -f keda/scaledObject.yaml

echo 'Producer deployment finished.'
popd
