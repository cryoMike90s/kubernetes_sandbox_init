#!/bin/bash
set -e

# Back up etcd only if this node is a control-plane (static pod manifest present)
if [ -f /etc/kubernetes/manifests/etcd.yaml ]; then
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  BACKUP_DIR="/var/lib/etcd-backup"
  mkdir -p "${BACKUP_DIR}"
  ETCDCTL_API=3 etcdctl snapshot save "${BACKUP_DIR}/etcd-snapshot-${TIMESTAMP}.db" \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key
  echo "etcd snapshot saved: ${BACKUP_DIR}/etcd-snapshot-${TIMESTAMP}.db"
fi

kubeadm reset -f

rm -rf $HOME:/etc/cni/net.d/10-calico.conflist
rm -rf $HOME:/etc/cni/net.d/calico-kubeconfig

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

ctr -n k8s.io i rm $(ctr -n k8s.io i ls -q)

sudo systemctl restart containerd

rm -rf $HOME/.kube/config
