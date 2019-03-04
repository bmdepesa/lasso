#!/bin/bash
# Get running or pending aws instances in JSON format -- pass additional options (--region) as second param
function aws_get_instances_json {
  stateColor=''
  name_filter="$1"
  additional_adopts="$2"
  if [ ! -z $name_filter ]; then filter="Name=tag:Name,Values=$name_filter"; fi
  aws ec2 describe-instances \
  $additional_opts \
  --filters $filter \
  --output json | \
  jq -jr '.Reservations[].Instances[] | { name: .Tags[] | select(.Key=="Name") | .Value, type: .InstanceType, id: .InstanceId, public: .PublicIpAddress, private: .PrivateIpAddress, state: .State.Name }'
  # select((.State.Name=="running") or (.State.Name=="pending")) |
}

# Get running or pending aws instances in a colorized table
function aws_get_instances {
  data="$(aws_get_instances_json $1 $2 | jq -r '"\(.name) \(.id) \(.type) \(.public) \(.private) \(.state)"')"
  
  end='\033[0m'
  green='\033[1;32m'
  red='\033[1;31m'
  yellow='\033[1;33m'
  cyan='\033[1;36m'

  sed_cmd_r="s|\brunning\b|\\${green}running\\${end}|g"
  sed_cmd_s="s|\bstopped\b|\\${yellow}stopped\\${end}|g"
  sed_cmd_p="s|\bpending\b|\\${cyan}pending\\${end}|g"
  sed_cmd_t="s|\bterminated\b|\\${red}terminated\\${end}|g"
  
  out=$(echo "$data" | sed "$sed_cmd_r" | sed "$sed_cmd_s" | sed "$sed_cmd_p" | sed "$sed_cmd_t" | column -t)
  echo -e $out
}

# Deletes AWS instances by ID
function aws_delete {
  aws_get_instances_json $1 $2 | jq -r '"\(.id)"' | while read p; do aws ec2 terminate-instances --instance-ids "$p"; done
}