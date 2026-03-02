#!/bin/bash

set -e

#kubeadm init --config ./configs/kubeconfig-control-plane.yaml
kubeadm init --config /root/kubernetes_sandbox_init/configs/kubeconfig-control-plane.yaml

#configuration set
export KUBECONFIG=/etc/kubernetes/admin.conf
 
# Project Calico
CALICO_VERSION=$(curl -s "https://api.github.com/repos/projectcalico/calico/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')
kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml"

# Calico custom-resources (operator Installation CR)
KUBEADM_CONFIG="/root/kubernetes_sandbox_init/configs/kubeconfig-control-plane.yaml"
curl -L -o /tmp/calico-custom-resources.yaml \
  "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/custom-resources.yaml"

POD_CIDR=$(grep -Po 'podSubnet:\s*\K\S+' "${KUBEADM_CONFIG}" || true)
if [ -n "${POD_CIDR}" ]; then
  sed -i "s|cidr: 192.168.0.0/16|cidr: ${POD_CIDR}|g" /tmp/calico-custom-resources.yaml
fi

kubectl apply -f /tmp/calico-custom-resources.yaml
