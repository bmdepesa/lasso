cd /etc/kubernetes/ssl
for file in $(find . -type f -name "*.pem"); do printf "$(md5sum $file)\n\n"; done
