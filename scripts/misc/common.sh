function random_string {
  cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | tr '[:upper:]' '[:lower:]'| fold -w ${1:-6} | head -n 1
}

function varNotSet {
  printf "Error: '$1' must be set! Exiting.\n"
  exit 1
}

function set_kube_config {
  if [ -z $1 ]
  then
    echo "kubeconfig: $KUBECONFIG"
  else
    export KUBECONFIG=$1
  fi
}

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
