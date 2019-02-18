helm install --name redis stable/redis \
 --values redis.yaml

helm install --name postgres stable/postgresql \
  --set postgresqlDatabase=gitlab


helm repo add gitlab https://charts.gitlab.io/
helm repo update

sendgrid_secret=`cat ~/sendgrid.txt`
kubectl create secret generic sendgrid-apikey --from-literal="password=$sendgrid_secret"

helm install --name gitlab gitlab/gitlab \
  --timeout 600 \
  --values gitlab.yaml
 
