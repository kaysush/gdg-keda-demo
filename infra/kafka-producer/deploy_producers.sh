#!/bin/sh

set -e

gcloud container clusters get-credentials keda-demo-cluster --zone us-central1-c --project neural-land-324105

echo 'Deploying KEDA to the cluster'
kubectl apply -f https://github.com/kedacore/keda/releases/download/v2.10.1/keda-2.10.1.yaml


echo 'Starting producer deployment...'
K8S_BASE_DIR=../../k8s

pushd $K8S_BASE_DIR

echo 'Deploying HPA based producer'
kubectl create namespace hpa-default
kubectl create secret generic api-secrets --namespace=hpa-default --from-literal=api_key=$API_KEY --from-literal=api_secret=$API_SECRET --from-literal=bootstrap_server=$BOOTSTRAP_SERVER
kubectl apply -f hpa/deployment.yaml
kubectl apply -f hpa/hpa.yaml

echo 'Deploying KEDA based producer'
kubectl create namespace hpa-keda
kubectl create secret generic api-secrets --namespace=hpa-keda --from-literal=api_key=$API_KEY --from-literal=api_secret=$API_SECRET --from-literal=bootstrap_server=$BOOTSTRAP_SERVER
kubectl apply -f keda/deployment.yaml
kubectl apply -f keda/triggerAuthentication.yaml
kubectl apply -f keda/scaledObject.yaml

echo 'Producer deployment finished.'
popd
