#!/bin/bash
export $(grep -v '^#' ~/.lasso/.config | xargs)
export $(grep -v '^#' ~/.lasso/rancher.config | xargs)

shopt -s expand_aliases
source $LASSO_HOME/activate
source $LASSO_HOME/scripts/misc/_common.sh

function usage {
  cat <<EOM
====
TODO (sorry)
====
EOM
  exit 2
}

if [ -z $1 ]; then usage; exit 0; fi

while [ "$1" != "" ]; do
  case $1 in
  	-n | --name ) shift; name=$1; ;;
    -h | --hostname ) shift; hostname=$1; ;;
    -z | --targetGroup80 ) shift; targetGroup80=$1; ;;
    -y | --targetGroup443 ) shift; targetGroup443=$1; ;;
    -t | --rancherImageTag ) shift; rancherImageTag=$1; ;;
    -c | --rancherChartRepo ) shift; rancherChartRepo=$1; ;;
    -s | --script ) shift; rancherInstallScript=$1; ;;
    -h | --help ) shift; usage; exit 0; ;;
    * ) usage; ;;
  esac
  shift
done

if [ -z $hostname ]; then varNotSet hostname; exit 1; fi
if [ -z $targetGroup80 ]; then varNotSet targetGroup80; exit 1; fi
if [ -z $targetGroup443 ]; then varNotSet targetGroup443; exit 1; fi
if [ -z $rancherImageTag ]; then varNotSet rancherImageTag; exit 1; fi
if [ -z $rancherChartRepo ]; then varNotSet rancherChartRepo; exit 1; fi
if [ -z $rancherInstallScript ]; then varNotSet rancherInstallScript; exit 1; fi
if [ -z $rkeYmlPath ]; then varNotSet rkeYmlPath; exit 1; fi
if [ -z $rkeTemplate ]; then varNotSet rkeTemplate; exit 1; fi
if [ -z $name ]; then varNotSet name; exit 1; fi

name=$name-$(random_string 6)
rkeYmlName=$name.yml
urlYml="set_server_url-$name.yml"
_urlTemplate='/templates/set-server-url-template.yml'

echo "Creating instances..."
aws_create --name $name --size t2.xlarge --count 3
sleep 10

echo "Getting instances information..."
instances_raw=$(aws_get_instances_json $name)

instances="$(echo $instances_raw | jq -jr '"\(" ",.id)"')"
instances_public="$(echo $instances_raw | jq -jr '"\(" ",.public)"')"
instances_private="$(echo $instances_raw | jq -jr '"\(" ",.private)"')"

instances_ar=(`echo ${instances}`)
instances_public_ar=(`echo ${instances_public}`)
instances_private_ar=(`echo ${instances_private}`)

echo "Waiting for instances to be running..."
for instance in ${instances_ar[@]}; do aws ec2 wait instance-running --instance-ids $instance; done

echo "Adding instances to target groups..."
for instance in ${instances_ar[@]}; do aws elbv2 register-targets --target-group-arn $targetGroup80 --targets Id=$instance; done
for instance in ${instances_ar[@]}; do aws elbv2 register-targets --target-group-arn $targetGroup443 --targets Id=$instance; done

echo "Generating RKE yml..."
_ymlPath=$LASSO_HOME$rkeYmlPath
_ymlFile=$LASSO_HOME$rkeYmlPath$rkeYmlName
cd $_ymlPath
cp $LASSO_HOME$rkeTemplate $_ymlFile

echo "File: $_ymlFile"

c=1; for ip in ${instances_public_ar[@]}; do echo $ip; sed -i "s/<addr$c>/$ip/g" $_ymlFile; c=$((c + 1)); done
c=1; for ip in ${instances_private_ar[@]}; do echo $ip; sed -i "s/<iaddr$c>/$ip/g" $_ymlFile; c=$((c + 1)); done

echo "Waiting for Docker to be running..."
sleep 60
# ssh wait for docker ps

echo "Executing RKE"
rke up --config $_ymlFile --ssh-agent-auth

echo "Setting kubeconfig..."
kc="kube_config_$rkeYmlName"
set_kube_config $_ymlPath$kc

source $LASSO_HOME$rancherInstallScript

echo Rancher HA setup completed!