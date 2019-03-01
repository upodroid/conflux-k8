## This is an implementation of ~~highly-available~~ WordPress install on Kubernetes

Set some variables before running the scripts/commands.

```
export REGION=europe-west1

export PROJECT=someprojectid

export IP_NAME=somename

export ZONE=europe-west1-b

export CLUSTER_NAME=somename
```

1. Create a cluster on GCP Console

```
gcloud container clusters create $CLUSTER_NAME \
  --zone $ZONE \
  --disk-type=pd-ssd \
  --disk-size=50GB \
  --machine-type=g1-small \
  --num-nodes=3 \
  --image-type ubuntu \
  --scopes compute-rw \
  --enable-autoscaling --max-nodes=6 --min-nodes=3 
```

`gcloud container clusters get-credentials $CLUSTER_NAME`

2. Install Helm 

  `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash `

3. Create a reserved ip on GCP

`gcloud compute addresses create $IP_NAME --region $REGION`

`export RESERVED_IP=$(gcloud compute addresses list --format='value(address)' --filter=name:$IP_NAME)`

Run the init.sh script

`init.sh | bash`

Useful bits

```
kubectl create clusterrolebinding "cluster-admin-$(whoami)" \
  --clusterrole=cluster-admin \
  --user="$(gcloud config get-value core/account)"
```


# USING Terraform

You can run this project using terraform.

Don't forget to change:
- IP variable in gitlab.yaml use gke_ip_address output from Terraform to find this out
- First RUN will fail because local creds for helm and kubectl don't exist yet. Grab the creds using gcloud and rerun terraform apply 
- Goodluck
- Login to awscli and gcloud SDK before hand