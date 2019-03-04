#!/bin/bash

# runonhosts to ssh into node
cd /etc/kubernetes/ssl
for file in $(find . -type f -name "*.pem"); do printf "$(md5sum $file)\n\n" > certs_hash.txt; done
#copy file out
