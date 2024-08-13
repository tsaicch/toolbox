#!/bin/bash
GITLAB_VERSION=$1 #15.4.6
#GITLAB_CHART_VERSION=$2 #6.4.6

IFS='.' read -r major minor patch <<< "$GITLAB_VERSION"
new_major=$(expr $major - 9)
GITLAB_CHART_VERSION="$new_major.$minor.$path"

env_init()
{
  wget -O helm.tar.gz https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz
  sudo tar xf helm.tar.gz --strip-components=1 -C /usr/bin/ linux-amd64/helm
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
helm template gitlab-temp gitlab/gitlab --version $GITLAB_CHART_VERSION --set global.hosts.domain=DOMAIN   --set certmanager-issuer.email=me@example.com|grep image:|awk -F: '{print $2":"$3}'|sed 's/"//g'|grep -v IfNotPrese|sed 's/@sha256//g' |sed 's/^[ \t]*//g'|tee $GITLAB_VERSION-gitlab-image-list

helm pull gitlab/gitlab --version $GITLAB_CHART_VERSION
helm search repo gitlab --versions|grep gitlab-runner #helm pull gitlab/gitlab-runner --versions 

#pull gitlab-ee image for gitaly and praefect
echo "FROM gitlab/gitlab-ee:$GITLAB_VERSION-ee.0" > Dockerfile
mylabbuild tsaicch/gitlab-$GITLAB_VERSION/gitlab-ee:$GITLAB_VERSION-ee.0


for i in `cat $GITLAB_VERSION-gitlab-image-list`;do echo "FROM $i" > Dockerfile; mylabbuild tsaicch/gitlab-$GITLAB_VERSION/$i;done
