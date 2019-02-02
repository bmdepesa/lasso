#!/bin/bash
name=""
size=""
count=""
keyname=""
securityGroup=""
subnet=""
ami=""
volumeSize=""
region=""
unique=false

# if config not present, give error, tell to run config script
export $(grep -v '^#' ~/.lasso/.config | xargs)
export $(grep -v '^#' ~/.lasso/aws.config | xargs)

source $LASSO_HOME/scripts/misc/common.sh

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
    -n | --name )  shift
                    name=$1
                    ;;
    -s | --size )  shift
                    size=$1
                    ;;
    -c | --count )  shift
                    count=$1
                    ;;
    -k | --keyname ) shift
                    keyname=$1
                    ;;
    -n | --subnet ) shift
                    subnet=$1
                    ;;
    -g | --sec-group ) shift
                    securityGroup=$1
                    ;;
    -a | --ami )    shift
                    ami=$1
                    ;;
    -v | --volsize ) shift
                    volumeSize=$1
                    ;;
    -r | --region ) shift
                    region=$1
                    ;;
    -u | --unique ) shift
                    unique=true
                    ;;
    -h | --help )   shift
                    usage
                    exit 0
                    ;;
    * )             usage; ;;
    esac
    shift
done

if [ -z $name ]; then varNotSet name; exit 0; fi
if [ -z $size ]; then varNotSet size; exit 0; fi
if [ -z $count ]; then varNotSet count; exit 0; fi
if [ -z $keyname ]; then varNotSet keyname; exit 0; fi
if [ -z $securityGroup ]; then varNotSet securityGroup; exit 0; fi
if [ -z $subnet ]; then varNotSet subnet; exit 0; fi
if [ -z $ami ]; then varNotSet ami; exit 0; fi
if [ -z $volumeSize ]; then varNotSet volumeSize; exit 0; fi
if [ -z $region ]; then varNotSet region; exit 0; fi

unique_suffix=$(random_string 6)
if [ $unique == "true" ]; then name=$name-$unique_suffix; fi

instances="$(aws ec2 run-instances \
  --image-id $ami \
  --count $count \
  --region $region \
  --instance-type $size \
  --key-name $keyname \
  --security-group-ids $securityGroup \
  --subnet-id $subnet \
  --block-device-mappings \
  "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":$volumeSize,\"DeleteOnTermination\":true}}]" | \
  jq -r '.Instances[] | { id: .InstanceId } | "\(.id)"')"

echo $instances | while read instance; do aws ec2 create-tags --resources $instance --tags Key=Name,Value=$name; done

echo "$instances"