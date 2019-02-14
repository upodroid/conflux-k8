helm install stable/redis \
 --values redis.yaml


helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
 --timeout 600 \
 --values=gitlab.yaml