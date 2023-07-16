## Creating Namespace and Deploying Credentials Secret

For the `deployment.yaml` to work you need to create a namespace and following secret in your namespace.

```

kubectl create namespace hpa-keda

kubectl create secret generic api-secrets --namespace=hpa-keda --from-literal=api_key=<YOUR-API-KEY> --from-literal=api_secret=<YOUR-API-SECRET> --from-literal=bootstrap_server=<YOUR-BOOTSTRAP-SERVER>

```