#!/bin/bash

user_flag='root'
script_flag=''
hosts_file_flag=''
hosts_string_flag=''
quiet_flag='false'

quiet_cmd=''
in_cmd=''

print_usage() {
  printf "Executes a local script on the provided remote hosts.\n\n"
  printf "Usage: runOnHosts.sh [-f hosts_file OR -h hosts_string] [-s script_to_run]\n"
  printf "\n"
  printf "Optional: [-u user (root)] [-q (Do not display ssh output)]\n"
  printf "\n" 
  printf "Note: Use ssh-agent ('ssh-add -K') to provide identity for remote hosts\n"
}

if [ $# -eq 0 ]
  then
  	print_usage
  	exit 1
fi

while getopts 'u:s:f:h:q' flag; do
  case "${flag}" in
    u) user_flag="${OPTARG}" ;;
    s) script_flag="${OPTARG}" ;;
    f) hosts_file_flag="${OPTARG}" ;;
    h) hosts_string_flag="${OPTARG}" ;;
    q) quiet_flag='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "$hosts_string_flag" ] &&  [ -z "$hosts_file_flag" ] ;
  then
    printf "No hosts specified.. Exiting.\n"
    exit 1
fi

if [ -z "${script_flag}" ]
  then
    printf "No script specified.. Exiting.\n"
    exit 1
fi

if [ -z "$hosts_string_flag" ]
  then
  	in_cmd=$(cat $hosts_file_flag)
  else
  	in_cmd="${hosts_string_flag}"
fi


if [ "$quiet_flag" == "true" ]
  then
  	quiet_cmd="> /dev/null 2>&1"
fi

IFS=' ' read -r -a s_args <<< "${script_flag}"

script_name=${s_args[0]}
args_string=''

for index in "${!s_args[@]}"; do
  if [ $index -ne "0" ]
    then
      args_string="${args_string}\"${s_args[index]}\" "
  fi 
done

printf "Script name: ${script_name}; s_args: ${args_string}\n"

for HOSTNAME in ${in_cmd}; do
  printf "Running '${script_flag}' on host: ${HOSTNAME}\n"
  ssh -o StrictHostKeyChecking=no -l ${user_flag} ${HOSTNAME} "bash -s" -- < "${script_name}" ${args_string} ${quiet_cmd}
done
