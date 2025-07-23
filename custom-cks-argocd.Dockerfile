# 使用 Argo CD 官方映像檔作為基礎
FROM quay.io/argoproj/argocd:v3.0.6

# 設定工作目錄
WORKDIR /usr/local/bin
USER root

# 安裝必要的工具：
# - gnupg 和 apt-transport-https 用於新增 Google Cloud SDK 倉庫
# - curl, telnet, iputils-ping (提供 ping), net-tools (提供 ifconfig 等) 是常用網路工具
# - ca-certificates 確保 HTTPS 連線正常
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnupg \
    apt-transport-https \
    curl \
    telnet \
    iputils-ping \
    net-tools \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 新增 Google Cloud SDK 的 APT 倉庫金鑰
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/cloud.google.gpg

# 新增 Google Cloud SDK 的 APT 倉庫
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# 更新 APT 軟體包清單並安裝 Google Cloud SDK 及 gke-gcloud-auth-plugin
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    google-cloud-sdk \
    kubectl \
    google-cloud-sdk-gke-gcloud-auth-plugin && \
    rm -rf /var/lib/apt/lists/*

USER 999
# 預設執行 Argo CD 命令 (如果基礎映像檔有定義)
