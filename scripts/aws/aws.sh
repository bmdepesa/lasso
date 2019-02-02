#!/bin/bash
# get running or pending aws instances -- pass additional options (--region) as second param
function aws_get_instances_json {
  name_filter="$1"
  additional_adopts="$2"
  if [ ! -z $name_filter ]; then filter="Name=tag:Name,Values=$name_filter"; fi
  aws ec2 describe-instances \
  $additional_opts \
  --filters $filter \
  --output json | \
  jq -jr '.Reservations[].Instances[] | select((.State.Name=="running") or (.State.Name=="pending")) | { name: .Tags[] | select(.Key=="Name") | .Value, type: .InstanceType, id: .InstanceId, public: .PublicIpAddress, private: .PrivateIpAddress, state: .State.Name }'
}

function aws_get_instances {
  aws_get_instances_json $1 $2 | jq -r '"\(.name) \(.id) \(.type) \(.public) \(.private) \(.state)"'
}

function aws_delete {
  aws_get_instances_json $1 $2 | jq -r '"\(.id)"' | while read p; do aws ec2 terminate-instances --instance-ids "$p"; done
}