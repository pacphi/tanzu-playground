# Tanzu Playground

This repository contains various automation scripts and samples related to the various products and technologies in the VMware Tanzu portfolio. It is intended to provide fast, easy, repeatable ways to create test and demo environments.

If you're interested in exploring how VMware is investing in the Kubernetes ecosystem then theres likely something here for you.

Some of the technologies showcased are:
- Tanzu Mission Control
- Tanzu Build Service (plus `kpack`)
- Tanzu Application Service (plus `cf-for-k8s`)
- Various uses of the `k14s` toolchain

## Terraform Modules

The Tanzu portfolio is compromised of various compomnents that work in the general Kubernetes ecosystem. The Terraform modules included in this repository are designed to standup not only Tanzu-native Kubernetes distributions, such as via Tanzu Mission Control, but also on GKE, EKS etc. Generally, these modules are designed to build fully functioning systems, and are self-contained in that they create as much of the supporting infrastructure as possible.

For example:
- Kubernetes clusters
- Configuring DNS (via Route53 etc.)
- Provisioning Lets Encrypt certificates via DNS solvers
- Installing Kubernetes foundational components, like 
  - Ingress
  - external-dns
  - cert-manager
- Installing components related to software supply chain like:
  - Concourse
  - Spinnaker

There are generally two types of modules included in the repository:
1. Abstract, self-contained, re-usable modules for specific functions
2. Aggregated modules that create tangible systems (for example `cf-on-k8s` on GKE)

Below is a summary of the aggregate modules that may be of immediate use.

| Module | Purpose | TMC (AWS) | GKE | EKS |
|---|---|---|---|---|
| `simple-cluster` | Basic Kubernetes cluster with ingress, external-dns and certmanager | [Link](terraform/tmc/simple-cluster/aws/README.md) | [Link](terraform/gke/simple-cluster/README.md) | [Link](terraform/eks/simple-cluster/README.md) |
| `cf-for-k8s` | Simple installation of Cloud Foundry on Kubernetes | [Link](terraform/tmc/cf-for-k8s/aws/README.md) | [Link](terraform/gke/cf-for-k8s/README.md) | [Link](terraform/eks/cf-for-k8s/README.md) |


### Providers

The modules in this repository may use one or more custom Terraform providers:
- A Tanzu Mission Control Terraform provider, which is currently internal to VMware (only required for TMC modules)

Please carefully study the `README` for each module to understand any corresponding custom module dependencies.