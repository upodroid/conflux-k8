#!/bin/bash
# Create namespaces fo OpenFaaS
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
helm repo add openfaas https://openfaas.github.io/faas-netes/

### SSL

helm install \
    --name cert-manager \
    --namespace kube-system \
    stable/cert-manager

kubectl apply -f lets-encrypt.yaml

###
# PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)

kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin \
--from-literal=basic-auth-password="$PASSWORD"
--set ingress.enabled=true

helm upgrade --install openfaas openfaas/ \
   --namespace openfaas \
   --reuse-values \
   --values faas-tls.yml \
   --set functionNamespace=openfaas-fn
