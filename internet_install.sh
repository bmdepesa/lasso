#!/bin/bash

if [ ! $(command -v git) ]; then 
    echo "Error: git must be installed and on the path. Aborting."; exit 1; \
fi

git clone https://github.com/bmdepesa/lasso
cd ./lasso
chmod +x install.sh
chmod +x config/configure.sh
./install.sh -c
