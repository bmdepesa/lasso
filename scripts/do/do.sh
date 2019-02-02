function tug_delete {
  if [ -z $1 ]
  then
    echo "Fuzzy name needed!"
  else
    tugboat droplets -a id | grep $1 | awk  -F',' '{print $2;}' | while read p; do tugboat destroy -c -i $p; done
  fi
}

#move keys to config
function tug_create {
  defaultKey=""
  if [ -z $2 ]; then
  	export $(grep -v '^#' ~/.lasso/do.config | xargs)
  else
  	defaultKey=$2
  fi

  if [[ -z $defaultKey || -z $1 ]]; then 
  	echo "Name and SSH Key ID are needed to create droplet!"
  else
  	tugboat create $1 --keys=$defaultKey	
  fi
}

function tugls {
  tugboat droplets -i | grep "$1"
}
