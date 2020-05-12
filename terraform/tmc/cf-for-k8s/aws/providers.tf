provider "aws" {
  region = var.region

  version = "~> 2.54.0"
}

provider "tmc" {
  api_key = var.tmc_key
}

provider "kubernetes" {
  host                   = data.tmc_kubeconfig.kubeconfig.server

  client_certificate     = base64decode(data.tmc_kubeconfig.kubeconfig.client_certificate)
  client_key             = base64decode(data.tmc_kubeconfig.kubeconfig.client_key)
  cluster_ca_certificate = base64decode(data.tmc_kubeconfig.kubeconfig.cluster_ca_certificate)

  load_config_file       = false

  version = "~> 1.11.0"
}

provider "helm" {
  version = "~> 1.2.0"

  kubernetes {
    host                   = data.tmc_kubeconfig.kubeconfig.server

    client_certificate     = base64decode(data.tmc_kubeconfig.kubeconfig.client_certificate)
    client_key             = base64decode(data.tmc_kubeconfig.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(data.tmc_kubeconfig.kubeconfig.cluster_ca_certificate)
    load_config_file       = false
  }
}

provider "k14s" {
  kapp {
    kubeconfig_yaml = module.kubeconfig.content
  }
}

locals {
  ytt_lib_dir = "${path.module}/../../../../ytt-libs"
}