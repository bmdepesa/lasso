# Gets the leader of the local cluster in an HA install
function rancher_get_ha_leader {
	kubectl get configmaps cattle-controllers -n kube-system -o json | \
	jq -r '.metadata.annotations["control-plane.alpha.kubernetes.io/leader"]' | \
	jq -r '.holderIdentity'
}

## Display the logs of the local cluster leader in an HA install [ -f=follow (optional) ]
#function rancher_get_ha_leader_logs {
#	kubectl logs -n cattle-system $(rgl) $1
#}
#
## Get the correct version of RKE based on the Rancher version [ rancherVersion (required) ]
#function rancher_get_rke {
#	# table of rancher versions to rke versions
#	# get the appropriate version of rke based on rancher version
#}
#
## Gets the generated Rancher password stored in the profile [ profileId (required) ]
#function rancher_get_password {
#  # get rancher password from config
#}
#
## Gets the path to the generated kubeconfig for the local cluster in an HA install
#function rancher_rancher_kubeconfig {
#  # get rancher kubeconfig
#}