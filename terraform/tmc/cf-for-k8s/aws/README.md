# Terraform: cf-for-k8s on AWS via Tanzu Mission Control

This Terraform module installs `cf-for-k8s` (Cloud Foundry on Kubernetes) using Tanzu Mission Control on AWS.

It will:
- Create a TMC cluster on AWS of the correct minimal size
- Configure a Pod Security Policy to allow privileged containers (necessary for Istio)
- Create an AWS Route53 DNS hosted zone and wire it up to an existing base zone
- Install `cf-for-k8s` from the official `ytt` configuration
- Install `external-dns` and ensure its configured correctly
- Installs Harbor registry in the cluster
- Configures `cf-for-k8s` to use that Harbor registry for buildpacks
- Output information to connect to the Cloud Foundry API endpoint
- Output information to access the Harbor registry

Example:

```
module "cf_for_k8s" {
  source = "github.com/pacphi/tanzu-playground//terraform/tmc/aws/cf-for-k8s"

  tmc_key             = "<tmc api key>"
  tmc_cluster_group   = "my-cluster-group"
  tmc_account_name    = "AWS-account"
  tmc_ssh_key_name    = "default"

  acme_email          = "cphillipson@pivotal.io"
  base_hosted_zone_id = "ZDZTEPQIQJB05"

  environment_name    = "demo"
  dns_prefix          = "demo"
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
- AWS account, with `aws` CLI logged in locally
- Terraform 0.12 installed
- Custom [terraform-provider-k14sx](https://github.com/niallthomson/terraform-provider-k14s) provider installed as a TF plugin
- `terraform-provider-tmc` installed (NOTE: This provider is currently not publicly available, contact @niallt on VMware Slack for information)
- DNS set up meeting the appropriate standards ([see here](/terraform/docs/dns.md))

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acme\_email | Email address that will be used for Lets Encrypt certificate registration | `string` | n/a | yes |
| base\_hosted\_zone\_id | The ID of the AWS Route53 DNS zone that already exists and is resolvable | `string` | n/a | yes |
| dns\_prefix | The DNS prefix that will be used to generate a unique domain from the base domain | `string` | n/a | yes |
| environment\_name | A name for the environment, which is used for various IaaS resources | `string` | n/a | yes |
| tmc\_account\_name | The Tanzu Mission Control account name to use | `string` | n/a | yes |
| tmc\_cluster\_group | The Tanzu Mission Control cluster group to use | `string` | n/a | yes |
| tmc\_key | A valid Tanzu Mission Control API key | `string` | n/a | yes |
| tmc\_ssh\_key\_name | The Tanzu Mission Control SSH key name | `string` | n/a | yes |
| availability\_zones | The AWS availability zones to use within the selected region | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| kubernetes\_version | Version of Kubernetes to use for the cluster | `string` | `"1.16.4-1-amazon2"` | no |
| master\_instance\_type | The EC2 instance type of the Kubernetes master nodes | `string` | `"m5.large"` | no |
| node\_pool\_instance\_type | The EC2 instance type of the Kubernetes worker nodes | `string` | `"m5.large"` | no |
| region | The AWS region in which components will be deployed | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_admin\_password | Cloud Foundry admin password |
| cf\_admin\_username | Cloud Foundry admin username |
| cf\_api\_endpoint | Cloud Foundry API endpoint |