# Generate a random string [ numberOfCharacters (optional, default=6) ]
function random_string {
  cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | tr '[:upper:]' '[:lower:]'| fold -w ${1:-6} | head -n 1
}

# PRIVATE
function varNotSet {
  printf "Error: '$1' must be set! Exiting.\n"
  exit 1
}

# Set KUBECONFIG to the provided path [ pathToCfg (required) ]
function set_kube_config {
  if [ -z $1 ]
  then
    echo "kubeconfig set to $KUBECONFIG"
  else
    export KUBECONFIG=$1
  fi
}

# PRIVATE
function lasso_logo {
	printf "\n"
	cat << "EOF"
===============================================================

                  \|/          (__)    
                       `\------(oo)
                         ||    (__)
                         ||w--||     \|/
                     \|/

                      _                  _                     
                     | |                | |                    
 _ __ __ _ _ __   ___| |__   ___ _ __   | | __ _ ___ ___  ___  
| '__/ _` | '_ \ / __| '_ \ / _ \ '__|  | |/ _` / __/ __|/ _ \ 
| | | (_| | | | | (__| | | |  __/ |     | | (_| \__ \__ \ (_) |
|_|  \__,_|_| |_|\___|_| |_|\___|_|     |_|\__,_|___/___/\___/ 
===============================================================
EOF
  printf "\n"
}

#function delete_data {
#  # deletes files in the data folders
#  # flag to remove any that don't belong to profiles
#  # 
#}
