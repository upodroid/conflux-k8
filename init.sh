#!/bin/bash
source vars.sh
# Install helm + login with project owner or container-admin SA
# More Args  https://github.com/helm/charts/tree/master/stable/nginx-ingress
echo "Run kubectl create secret generic mysql --from-literal=password=somepw first before running this script. "
echo "Also run kubectl create secret tls upodroid --key key.pem --cert cert.pem"

gcloud container clusters get-credentials $CLUSTER_NAME

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value core/account)
  
sleep 5
while true; do
    read -p "Have you set the env variable RESERVED_IP, authenticated kubectl with acc that has owner or container admin role and set the secret for mysql? " yn
    case $yn in
        [Yy]* ) kubectl create serviceaccount --namespace kube-system tiller
        kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
        helm init --service-account tiller --wait
        helm install --name nginx-ingress stable/nginx-ingress --set controller.service.loadBalancerIP=$RESERVED_IP; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)
echo $PASSWORD > mysql-$(date +%d-%m-%y).txt
kubectl create secret generic mysql --from-literal=password=$PASSWORD
bash ./ssl/ssl.sh


