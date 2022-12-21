#!/bin/bash

wget -O packer.zip https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip
unzip packer.zip
mkdir .packer.d
export CHECKPOINT_DISABLE=1
export PACKER_HOME_DIR=$(pwd)
export PACKER_CONFIG_DIR=$(pwd)/.packer.d
