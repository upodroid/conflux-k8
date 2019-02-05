## This is an implementation of ~~highly-available~~ WordPress install on Kubernetes

`export $REGION
export $IP-NAME`

1. Create a cluster on GCP Console

2. Install Helm 

  `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash `

3. Create a reserved ip on GCP

`gcloud compute addresses create $NAME --region $REGION`

export RESERVED_IP=$(gcloud compute addresses list --format='value(address)' --filter=name:NAME)

