# Terraform: cf-for-k8s on GKE

This Terraform module installs `cf-for-k8s` (Cloud Foundry on Kubernetes) on Google Kubernetes Engine.

It will:
- Create a GKE cluster of the correct minimal size
- Create a Google Cloud DNS hosted zone and wire it up to an existing base zone
- Install `cf-for-k8s` from the official `ytt` configuration
- Install `external-dns` and ensure its configured correctly
- Installs Harbor registry in the cluster
- Configures `cf-for-k8s` to use that Harbor registry for buildpacks
- Output information to connect to the Cloud Foundry API endpoint
- Output information to access the Harbor registry

Example:

```
module "cf_for_k8s" {
  source = "github.com/pacphi/tanzu-playground//terraform/gke/cf-for-k8s"

  acme_email          = "cphillipson@pivotal.io"
  base_zone_name      = "paasify-zone"

  environment_name    = "demo"
  dns_prefix          = "demo"

  project             = "fe-cphillipson"
}

output "cf_api_endpoint" {
  value       = module.cf_for_k8s.cf_api_endpoint
}

output "cf_admin_username" {
  value       = module.cf_for_k8s.cf_admin_username
}

output "cf_admin_password" {
  value       = module.cf_for_k8s.cf_admin_password
}

output "harbor_endpoint" {
  value       = module.cf_for_k8s.harbor_endpoint
}

output "harbor_admin_username" {
  value       = module.cf_for_k8s.harbor_admin_username
}

output "harbor_admin_password" {
  value       = module.cf_for_k8s.harbor_admin_password
}
```

## Pre-requisites

The following are pre-requisites to run the above Terraform:
- Google Cloud Platform account, with `gcloud` logged in locally
- Terraform 0.12 installed
- Custom [terraform-provider-k14sx](https://github.com/niallthomson/terraform-provider-k14s) provider installed as a TF plugin
- DNS set up meeting the appropriate standards ([see here](/terraform/docs/dns.md))

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acme\_email | Email address that will be used for Lets Encrypt certificate registration | `string` | n/a | yes |
| base\_zone\_name | The name of the Google Cloud DNS zone that already exists and is resolvable | `string` | n/a | yes |
| dns\_prefix | The DNS prefix that will be used to generate a unique domain from the base domain | `string` | n/a | yes |
| environment\_name | A name for the environment, which is used for various IaaS resources | `string` | n/a | yes |
| project | The Google Cloud project to use | `string` | n/a | yes |
| region | The GCP region where the resources will be deployed | `string` | `"us-central1"` | no |
| zone | The default GCP zone to use where applicable | `string` | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_admin\_password | Cloud Foundry admin password |
| cf\_admin\_username | Cloud Foundry admin username |
| cf\_api\_endpoint | Cloud Foundry API endpoint |

## Usage

* Author `main.tf` (consult example above)
* Execute `terraform init`
* Fetch `vendor` directory for `cf_for_k8s` Terraform module
  * `cd .terraform/modules/cf_for_k8s/ytt-libs/cf-for-k8s && vendir sync && cd ../../../../..`
* Execute `terraform plan`
* Execute `terraform apply -auto-approve`