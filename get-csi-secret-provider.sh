#!/bin/bash
SECRET_CSI_VERSION=1.3.4
SECRET_CSI_CHART_VERSION=1.3.4

env_init()
{
  wget -O helm.tar.gz https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz
  sudo tar xf helm.tar.gz --strip-components=1 -C /usr/bin/ linux-amd64/helm
}

if ! command -v helm &> /dev/null; then
        env_init
fi

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm search repo secrets-store-csi-driver --versions

helm template secrets-store-csi-driver-temp secrets-store-csi-driver/secrets-store-csi-driver --version $SECRET_CSI_CHART_VERSION|grep image|awk -F: '{print $2":"$3}'|sed 's/"//g'|grep -v IfNotPrese|sed 's/@sha256//g' |sed 's/^[ \t]*//g'|tee $SECRET_CSI_VERSION-secrets-store-csi-driver-image-list

helm pull secrets-store-csi-driver/secrets-store-csi-driver --version $SECRET_CSI_CHART_VERSION
#echo "FROM gitlab/gitlab-ee:$GITLAB_VERSION-ee.0" > Dockerfile
#mylabbuild tsaicch/gitlab-$GITLAB_VERSION/gitlab-ee:$GITLAB_VERSION-ee.0

for i in `cat $SECRET_CSI_VERSION-secrets-store-csi-driver-image-list`;do echo "FROM $i" > Dockerfile; mylabbuild tsaicch/secrets-store-csi-driver-$SECRET_CSI_VERSION/$i;done

## for secret-provider-class gcp plugin
wget -O provider-gcp-plugin.yaml https://raw.githubusercontent.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp/main/deploy/provider-gcp-plugin.yaml
echo "FROM " > Dockerfile
cat provider-gcp-plugin.yaml|grep image:|awk '{print $2}' >> Dockerfile
mylabbuild tsaicch/secrets-store-csi-driver-gcp-plugin
