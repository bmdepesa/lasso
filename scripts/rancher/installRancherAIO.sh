#!/bin/bash

print_usage() {
  printf "Installs Rancher with the specified version\n"
  printf "installRancherAIO.sh <version>\n"
}

if [ $# -eq 0 ]
  then
    print_usage
    exit 1
fi

rancher_version=$1

curl https://releases.rancher.com/install-docker/17.03.sh | sh 

docker run -v /home/ubuntu/state:/var/lib/rancher \
  -d -p 80:80 -p 443:443 \
  --restart=unless-stopped \
  rancher/rancher:$rancher_version
