#!/bin/bash
source vars.sh
gcloud container clusters create $CLUSTER_NAME \
 --num-nodes=3 \
 --disk-size=50 \
 --enable-ip-alias \
 --machine-type g1-small \
 --no-enable-legacy-authorization \
 --image-type ubuntu \
 --zone europe-west2-b 