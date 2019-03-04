#!/bin/bash
export $(grep -v '^#' ~/.lasso/.config | xargs)

source $LASSO_HOME/activate

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

cd /Users/bmdepesa/Dev/Projects/rancher/bin/chart/dev/rancher

helm install ./ \
  --name rancher \
  --namespace cattle-system \
  --set hostname=$hostname \
  --set rancherImageTag=$rancherImageTag \
  --set busyboxImage=prom/busybox:latest

cd $LASSO_HOME

echo "Waiting for rancher to be available"
sleep 60
# poll for 200 status

echo "Reseting the admin password"

echo $(kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password)
# copy to clipboard
# save to datafile with path to kubeconfig

echo "Setting server-url"
_ymlFile=$LASSO_HOME$rkeYmlPath$urlYml
cd $_ymlPath
cp $LASSO_HOME$_urlTemplate $_ymlFile
sed -i "s/<hostname>/$hostname/g" $_ymlFile

kubectl apply -f $_ymlFile