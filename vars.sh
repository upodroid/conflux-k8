export IP_NAME=gke
export CLUSTER_NAME=maker
export RESERVED_IP=$(gcloud compute addresses list --format='value(address)' --filter=name:$IP_NAME)
