#!/bin/bash
export $(grep -v '^#' ~/.lasso/.config | xargs)

shopt -s expand_aliases
source $LASSO_HOME/activate
source $LASSO_HOME/scripts/misc/common.sh

helm repo update

if [ -z $hostname ]; then varNotSet hostname; exit 1; fi
if [ -z $rancherChartRepo ]; then varNotSet rancherChartRepo; exit 1; fi
if [ -z $rancherImageTag ]; then varNotSet rancherImageTag; exit 1; fi

echo "Installing Rancher via Helm"

kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller

echo "Waiting for tiller..."
sleep 60

helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system \
  --version v0.5.2

helm install $rancherChartRepo \
  --name rancher \
  --namespace cattle-system \
  --set hostname=$hostname \
  --set rancherImageTag=$rancherImageTag