FROM nextcloud:27.0.2
RUN apt-get update -y && apt-get install -y \
    nfs-common \
    nfs-kernel-server \
    libtool \
    & apt-get clean
COPY entrypoint.sh /entrypoint.sh
