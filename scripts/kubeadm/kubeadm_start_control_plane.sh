#!/bin/bash

set -e

kubeadm init --config ./configs/kubeconfig-control-plane.yaml

# Project Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml
