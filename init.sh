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

gcloud container clusters get-credentials $CLUSTER_NAME

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
#bash ./ssl/ssl.sh


