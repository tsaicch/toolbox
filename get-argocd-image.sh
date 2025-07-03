#!/bin/bash
ARGOCD_VERSION=$1 #8.1.2
#ARGOCD_CHART_VERSION=$2 #8.1.2

# IFS='.' read -r major minor patch <<< "$ARGOCD_VERSION"
# echo $major
# new_major=$(expr $major - 9)
# ARGOCD_CHART_VERSION="$new_major.$minor.$patch"
# echo $ARGOCD_CHART_VERSION

env_init()
{
  wget -O helm.tar.gz https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz
  sudo tar xf helm.tar.gz --strip-components=1 -C /usr/bin/ linux-amd64/helm
}

if ! command -v helm &> /dev/null; then
        env_init
fi


helm repo add argo https://argoproj.github.io/argo-helm
helm search repo argo/argo-cd --versions


helm template argocd-temp argo/argo-cd |grep image:|awk -F: '{print $2":"$3}'|sed 's/"//g'|grep -v IfNotPrese|sed 's/@sha256//g' |sed 's/^[ \t]*//g'|sort|uniq|tee $ARGOCD_VERSION-argocd-image-list
helm pull argo/argo-cd --version $ARGOCD_VERSION

for i in `cat $ARGOCD_VERSION-argocd-image-list`;do echo "FROM $i" > Dockerfile; mylabbuild tsaicch/argocd-$ARGOCD_VERSION/$i;done
