function rancher_get_ha_leader {
	kubectl get configmaps cattle-controllers -n kube-system -o json | \
	jq -r '.metadata.annotations["control-plane.alpha.kubernetes.io/leader"]' | \
	jq -r '.holderIdentity'
}

function rancher_get_ha_leader_logs {
	kubectl logs -n cattle-system $(rgl) $1
}
