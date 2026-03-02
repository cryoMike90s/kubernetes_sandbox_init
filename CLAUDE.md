# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository automates the setup of a Kubernetes sandbox cluster using kubeadm, containerd, Calico CNI, and Flux CD for GitOps. It is a companion to the `kubernetes_sandbox` repository (which holds the cluster manifests).

## Development Environment

Uses [Devbox](https://www.jetify.com/devbox) for a reproducible local environment with kubectl, helm, flux, k9s, go, python, and other tools pre-installed.

```bash

## Architecture

```
configs/
  kubeconfig-control-plane.yaml   # kubeadm ClusterConfiguration (cluster: sandbox, k8s v1.34.1)
devbox/
  devbox.json                     # Nix-based dev environment with 26 tools
scripts/
  kubeadm/                        # Cluster lifecycle (prereqs, init, reset)
  flux/                           # Flux CD bootstrap + .env for SSH key path
  helm_install.sh                 # Dynamic latest-release install via GitHub API
  krew.sh                         # Cross-platform Krew installer
  kubectx.sh                      # Clones and installs kubectx/kubens
  cert-manager.sh                 # cert-manager kubectl plugin
```

**Key configuration details:**
- Container runtime: containerd with `SystemdCgroup = true`
- CNI: Project Calico v3.31.0
- Service subnet: `10.96.0.0/16`, DNS domain: `cluster.local`
- Flux targets: `cryoMike90s/kubernetes_sandbox` repo, `clusters/sandbox` path
- Flux extra components: `image-reflector-controller`, `image-automation-controller`
