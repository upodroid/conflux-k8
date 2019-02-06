## This is an implementation of ~~highly-available~~ WordPress install on Kubernetes

Set some variables before running the scripts/commands.

```
export REGION=europe-west1

export PROJECT=someprojectid

export IP-NAME=somename

export ZONE=europe-west1-b

export CLUSTER-NAME=somename
```

1. Create a cluster on GCP Console

```
gcloud container clusters create $CLUSTER-NAME \
  --zone $ZONE \
  --disk-type=pd-ssd \
  --disk-size=50GB \
  --machine-type=g1-small \
  --num-nodes=3 \
  --image-type ubuntu \
  --scopes compute-rw \
  --enable-autoscaling --max-nodes=6 --min-nodes=3 
```

`gcloud container clusters get-credentials $CLUSTER-NAME`

2. Install Helm 

  `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash `

3. Create a reserved ip on GCP

`gcloud compute addresses create $IP-NAME --region $REGION`

`export RESERVED_IP=$(gcloud compute addresses list --format='value(address)' --filter=name:NAME)`

Run the init.sh script

`init.sh | bash`
