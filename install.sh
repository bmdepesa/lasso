#!/bin/bash
configure_flag="-c"

required_apps="kubectl aws jq rke tugboat"
LASSO_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $LASSO_HOME/scripts/misc/common.sh

lasso_logo

for app in $required_apps; do 
  if [ ! $(command -v $app) ]; then 
    echo "Error: $app must be installed and on the path. Aborting."; exit 1; \
  fi
done

mkdir -p $HOME/.lasso/
echo "LASSO_HOME=$LASSO_HOME" > $HOME/.lasso/.config

printf "LASSO_HOME is $LASSO_HOME\n\n"
echo ".config created"

if [ ! -f $HOME/.lasso/aws.config ]; then
  cp $LASSO_HOME/config/aws.config $HOME/.lasso/
  echo "Default AWS config created"
else
  echo "AWS config already present, skipping creation."
fi

if [ ! -f $HOME/.lasso/do.config ]; then
  cp $LASSO_HOME/config/do.config $HOME/.lasso/
  echo "Default DO config created"
else
  echo "DO config already present, skipping creation"
fi

printf "Setting permissions on scripts\n\n"
chmod -R 755 $LASSO_HOME/scripts
chmod 755 $LASSO_HOME/config/configure.sh

if [ "$1" == $configure_flag ]; then source "$LASSO_HOME/config/configure.sh"; fi

function addSources {
	cat <<EOT >> $1

export LASSO_HOME=$LASSO_HOME
source $LASSO_HOME/_activate
EOT
}

echo "Adding sources to default rc files"
addSources $HOME/.bashrc
addSources $HOME/.zshrc
addSources $HOME/.bash_profile

printf "\nInstall completed! Restart your session to begin using lasso! \n\n"
