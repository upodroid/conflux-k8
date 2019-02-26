#!/bin/bash
source vars.sh
rm -rf ~/.kube || true
rm -rf ~/.helm || true

cluster=$(gcloud container clusters list --format 'value(name)' | grep "$CLUSTER_NAME")
echo
if [ "$cluster" == "$CLUSTER_NAME" ]
then
  gcloud container clusters delete $$CLUSTER_NAME --quiet
else
  echo "The cluster you mentioned can't be found"

gcloud container clusters create $CLUSTER_NAME \
 --num-nodes=3 \
 --disk-size=50 \
 --enable-ip-alias \
 --machine-type n1-standard-2 \
 --no-enable-legacy-authorization \
 --image-type ubuntu \
 --zone europe-west2-b 

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
#kubectl create secret tls upodroid-com-tls --key ~/certs/key.pem --cert ~/certs/cert.pem

# Mail Config
sendgrid_secret=`cat ~/sendgrid.txt`
kubectl create secret generic sendgrid-apikey --from-literal="password=$sendgrid_secret"


## Install Helm chatrt for gitlab
helm install --name gitlab gitlab/gitlab \
  --timeout 600 \
  --values gitlab.yaml
 
