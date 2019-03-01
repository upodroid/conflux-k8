#!/bin/bash
source vars.sh
rm -rf ~/.kube || true
rm -rf ~/.helm || true

gcloud container clusters get-credentials $CLUSTER_NAME

# Install helm + login with project owner or container-admin SA
# More Args  https://github.com/helm/charts/tree/master/stable/nginx-ingress

# Avoids RBAC Errors
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value core/account)
  
sleep 5
while true; do
    read -p "Are you ready to install Tiller on the Cluster? " yn
    case $yn in
        [Yy]* ) kubectl apply -f tiller.yaml
        kubectl apply -f pv.yaml
        helm init --service-account tiller --wait ;
        break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

#APP Scripts
PASSWORD=$(head -c 12 /dev/urandom | shasum | cut -d' ' -f1)
#echo $PASSWORD > mysql-$(date +%d-%m-%y).txt
kubectl create secret generic mysql --from-literal=password=$PASSWORD


## Install helm charts
helm install --name nginx-ingress stable/nginx-ingress \
  --values nginx-ingress.yaml

helm install --name redis stable/redis \
 --values redis.yaml

helm install --name postgres stable/postgresql \
  --set postgresqlDatabase=gitlab



#Install Cert-manager and Issuer
bash ssl.sh

helm repo add gitlab https://charts.gitlab.io/
helm repo update
#kubectl create secret tls borg-dev-tls --key ~/certs/key.pem --cert ~/certs/cert.pem

## Object Store Secrets
kubectl create secret generic gcs-storage \
    --from-file=connection=$HOME/creds/rails.yaml ##AppConfig Secrets

kubectl create secret generic registry-credentials \
    --from-file=config=registry.yaml \
    --from-file=gcs.json=$HOME/creds/ansible.json #Registry Secrets

kubectl create secret generic gcs-config --from-file=config=$HOME/creds/gcs.config #Backups secret


# Mail Config
sendgrid_secret=`cat ~/sendgrid.txt`
kubectl create secret generic sendgrid-apikey --from-literal="password=$sendgrid_secret"


## Install Helm chart for gitlab
helm install --name gitlab gitlab/gitlab \
  --timeout 600 \
  --values gitlab.yaml
 
