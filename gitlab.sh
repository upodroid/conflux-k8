helm install --name redis stable/redis \
 --values redis.yaml


helm repo add gitlab https://charts.gitlab.io/
helm repo update

sendgrid_secret=`cat ~/sendgrid.txt`
kubectl create secret generic sendgrid-apikey --from-literal="password=$sendgrid_secret"

helm install --name gitlab gitlab/gitlab \
  --timeout 600 \
  --set redis.enabled=false \
  --set certmanager-issuer.email=hi@upo.one \
  --set global.hosts.domain=upodroid.com \
  --set global.hosts.externalIP=$RESERVED_IP \
  --set global.redis.host=redis-master \
  --set global.redis.password.secret=redis \
  --set global.redis.password.key=redis-password \
  --set gitlab.migrations.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce \
  --set gitlab.sidekiq.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce \
  --set gitlab.unicorn.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-unicorn-ce \
  --set gitlab.unicorn.workhorse.image=registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce \
  --set gitlab.task-runner.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-task-runner-ce 
