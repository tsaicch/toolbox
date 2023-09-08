#!/bin/bash
GITLAB_VERSION=15.4.6
GITLAB_CHART_VERSION=6.4.6

env_init()
{
  wget -O helm.tar.gz https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz
  tar xf helm.tar.gz --strip-components=1 -C /usr/bin/ linux-amd64/helm
}

if ! command -v helm &> /dev/null; then
        env_init
fi

helm repo add gitlab https://charts.gitlab.io/
helm search repo gitlab --versions
#download chart as file
#helm pull teleport/teleport-cluster --version 13.1.5
# versions is chart version
#helm template gitlab15-4-6 gitlab/gitlab --version 6.4.6 --set global.hosts.domain=DOMAIN   --set certmanager-issuer.email=me@example.com
#helm template gitlab15-4-6 gitlab/gitlab --version 6.4.6 --set global.hosts.domain=DOMAIN   --set certmanager-issuer.email=me@example.com|grep image|awk -F: '{print $2":"$3}'|sed 's/"//g'|grep -v IfNotPrese
helm template gitlab-temp gitlab/gitlab --version $GITLAB_CHART_VERSION --set global.hosts.domain=DOMAIN   --set certmanager-issuer.email=me@example.com|grep image|awk -F: '{print $2":"$3}'|sed 's/"//g'|grep -v IfNotPrese|sed 's/@sha256//g' |sed 's/^[ \t]*//g'|tee $GITLAB_VERSION-gitlab-image-list

helm pull gitlab/gitlab --version $GITLAB_CHART_VERSION

for i in `cat $GITLAB_VERSION-gitlab-image-list`;do echo "FROM $i" > Dockerfile; mylabbuild tsaicch/$i;done
