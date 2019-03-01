#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml

kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

helm repo update

helm install \
  --name cert-manager \
  --namespace cert-manager \
  stable/cert-manager

sleep 20

aws_secret=`cat ~/.aws/secret.txt`
kubectl --namespace cert-manager create secret generic route53-credentials --from-literal="secret-access-key=$aws_secret"


kubectl apply -f ./issuer.yaml
kubectl apply -f ./cert.yaml

## Replicate cert to all namesspaces using kubed
helm repo add appscode https://charts.appscode.com/stable/
helm repo update
helm install appscode/kubed --name kubed --namespace kube-system \
    --set apiserver.ca="$(onessl get kube-ca)" \
    --set config.clusterName=maker 

sleep 10

kubectl annotate secret upodroid-com-tls -n cert-manager kubed.appscode.com/sync="app=kubed"
kubectl label namespace default app=kubed
