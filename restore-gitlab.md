Retore start from here
https://docs.gitlab.com/charts/backup-restore/restore/

# install new gitlab 
helm template -n gitlab gitlab gitlab/gitlab \
  --version 8.2.9 \
  --set certmanager.install=false \
  --set global.ingress.enabled=false \
  --set nginx-ingress.enabled=false \
  --set global.kas.enabled=false \
  --set gitlab-runner.install=false \
  --set global.hosts.https=false \
  --set global.hosts.gitlab.https=false \
  --set gitlab.migrations.resources.requests.memory=2Gi \
  --set gitlab.toolbox.persistence.enabled=true \
  --set gitlab.toolbox.persistence.size=15Gi \
  --set gitlab.toolbox.resources.requests={'cpu':'2250m', 'memory':'2250M'} \
  -f no-tls.yaml

# re-create rails secret 與來源環境相同 uat-cmp or prod-cmp

# recreate pod to use correct rails secret
kubectl delete pods -lapp=sidekiq,release=gitlab -n gitlab
kubectl delete pods -lapp=webservice,release=gitlab -n gitlab
kubectl delete pods -lapp=toolbox,release=gitlab -n gitlab

# scale down pod

kubectl scale deploy -lapp=sidekiq,release=gitlab -n gitlab --replicas=0
kubectl scale deploy -lapp=webservice,release=gitlab -n gitlab --replicas=0
kubectl scale deploy -lapp=prometheus,release=gitlab -n gitlab --replicas=0

# Modify toolbox deployment to increase CPU and hostAlias
# - toolbox pod需要多點CPU以免restore失敗
# - toolbox 增加hostAlias minio.example.com <-> minio-svc mapping
# - gitaly statefulset 需要多一點CPU與RAM以免失敗

# kubecl cp gitlab-backup to toolbox pod的 /srv/gitlab/tmp 中

# restore gitlab
backup-utility --restore --skip uploads --skip registry --skip lfs -f file:///srv/gitlab/tmp/uat-cmp-1743026474_2025_03_26_17.2.9-ee_gitlab_backup.tar

--- skip options
db (database)
repositories (Git repositories data, including wikis)
uploads (attachments)
artifacts (CI job artifacts and output logs)
pages (Pages content)
lfs (LFS objects)
terraform_state (Terraform states)
registry (Container registry images)
packages (Package registry)
ci_secure_files (Project-level Secure Files)
external_diffs (Merge request diffs)

---
content of no-tls.yaml

```yaml
global:
  # https://docs.gitlab.com/charts/charts/globals#configure-ingress-settings
  ingress:
    enabled: false
    configureCertmanager: false
    tls:
      enable: false
      #  https://docs.gitlab.com/charts/charts/globals#configure-host-settings
  hosts:
    https: false # this disables HTTPS urls for all hosts
cert-manager:
  install: false
nginx-ingress:
  enabled: false
```

### note 
## verfiy root login
# get init-root password
```bash
kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 -d >> /tmp/gitlab-init
gsutil cp /tmp/gitlab-init gs://guae19bkt0003isb-usrdata/tsaicch@tsmc.com/
```
# create gitlab-railes with cmp secret
kubectl create secret generic -n gitlab gitlab-rails-secret --from-file=secrets.yml=uat-cmp-gitlab-rails-secrets.yaml
kubectl get secret -n gitlab gitlab-rails-secret -ojsonpath='{.data.secrets\.yml}' | yq '@base64d | from_yaml | .production' -o json > uat-cmp-rails-secrets.json
