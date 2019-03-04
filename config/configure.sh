#!/bin/bash
printf "\nLasso Configuration: \n\n"
printf "AWS CONFIG:\n\n"

if [ -f ~/.lasso/aws.config ]; then
  export $(grep -v '^#' ~/.lasso/aws.config | xargs)
fi

read -p "Default keypair name [$keyname]: " \
  _keyname </dev/tty; if [ ! -z $_keyname ]; then keyname=$_keyname; fi

read -p "Default security group [$securityGroup]: " \
  _securityGroup </dev/tty; if [ ! -z $_securityGroup ]; then securityGroup=$_securityGroup; fi

read -p "Default subnet [$subnet]: " \
  _subnet </dev/tty; if [ ! -z $_subnet ]; then subnet=$_subnet; fi

read -p "Default ami [$ami]: " \
  _ami </dev/tty; if [ ! -z $_ami ]; then ami=$_ami; fi

read -p "Default volume size [$volumeSize]: " \
  _volumeSize </dev/tty; if [ ! -z $_volumeSize ]; then volumeSize=$_volumeSize; fi

read -p "Default instance size [$size]: " \
  _size </dev/tty; if [ ! -z $_size ]; then size=$_size; fi

read -p "Default region [$region]: " \
  _region </dev/tty; if [ ! -z $_region ]; then region=$_region; fi

cat<<EOT >~/.lasso/aws.config
keyname=$keyname
securityGroup=$securityGroup
subnet=$subnet
ami=$ami
volumeSize=$volumeSize
size=$size
region=$region
EOT

printf "\nDO CONFIG:\n\n"

if [ -f ~/.lasso/do.config ]; then
  export $(grep -v '^#' ~/.lasso/do.config | xargs)
fi

read -p "Default SSH key id [$defaultKey]: " \
  _keyid </dev/tty; if [ ! -z $_keyid ]; then defaultKey=$_keyid; fi

cat<<EOT >~/.lasso/do.config
defaultKey=$defaultKey
EOT

printf "\nRANCHER CONFIG:\n\n"

if [ -f ~/.lasso/rancher.config ]; then
  export $(grep -v '^#' ~/.lasso/rancher.config | xargs)
fi 

read -p "Hostname for HA install [$hostname]: " \
  _hostname </dev/tty; if [ ! -z $_hostname ]; then hostname=$_hostname; fi

read -p "ARN for target group 80 [$targetGroup80]: " \
  _target80 </dev/tty; if [ ! -z $_target80 ]; then targetGroup80=$_target80; fi

read -p "ARN for target group 443 [$targetGroup443]: " \
  _target443 </dev/tty; if [ ! -z $_target443 ]; then targetGroup443=$_target443; fi

read -p "rancher image tag [$rancherImageTag]: " \
  _rimgtag </dev/tty; if [ ! -z $_rimgtag ]; then rancherImageTag=$_rimgtag; fi

read -p "rancher chart repo [$rancherChartRepo]: " \
  _rcr </dev/tty; if [ ! -z $_rcr ]; then rancherChartRepo=$_rcr; fi

read -p "rancher HA install script [$rancherInstallScript]: " \
  _ris </dev/tty; if [ ! -z $_ris ]; then rancherInstallScript=$_ris; fi

read -p "rke yml path [$rkeYmlPath]: " \
  _ryp </dev/tty; if [ ! -z $_ryp ]; then rkeYmlPath=$_ryp; fi

read -p "rke yml HA template [$rkeTemplate]: " \
  _rt </dev/tty; if [ ! -z $_rt ]; then rkeTemplate=$_rt; fi

cat<<EOT >~/.lasso/rancher.config
hostname=$hostname
targetGroup80=$targetGroup80
targetGroup443=$targetGroup443
rancherImageTag=$rancherImageTag
rancherChartRepo=$rancherChartRepo
rancherInstallScript=$rancherInstallScript
rkeYmlPath=$rkeYmlPath
rkeTemplate=$rkeTemplate
EOT

echo "Configuration completed!"