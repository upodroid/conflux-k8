#!/bin/bash
# Create namespaces fo OpenFaaS
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
helm repo add openfaas https://openfaas.github.io/faas-netes/

### SSL

kubectl apply \
    -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml

helm install \
    --name cert-manager \
    --namespace kube-system \
    stable/cert-manager

kubectl apply -f lets-encrypt.yaml
kubectl apply -f let-encrypt-crt.yaml

###
# PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)

kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin \
--from-literal=basic-auth-password="$PASSWORD"

helm repo update \
 && helm upgrade openfaas --install openfaas/openfaas \
    --namespace openfaas  \
    --set basic_auth=true \
    --set functionNamespace=openfaas-fn

sleep 30

helm upgrade openfaas \
    --namespace openfaas \
    --reuse-values \
    --values faas-tls.yaml \
    openfaas/openfaas

    

