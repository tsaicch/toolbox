#!/bin/bash
echo "set cursorline
set cursorcolumn
set hlsearch
set number" > ~/.vimrc


sudo apt install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
