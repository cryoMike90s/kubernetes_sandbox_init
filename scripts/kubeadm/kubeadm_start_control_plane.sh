#!/bin/bash

set -e

#kubeadm init --config ./configs/kubeconfig-control-plane.yaml
kubeadm init --config /root/kubernetes_sandbox_init/configs/kubeconfig-control-plane.yaml

#configuration set
export KUBECONFIG=/etc/kubernetes/admin.conf
 
# Project Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/calico.yaml
