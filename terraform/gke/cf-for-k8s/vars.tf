variable "environment_name" {
  description = "A name for the environment, which is used for various IaaS resources"
  type        = string
}

variable "acme_email" {
  description = "Email address that will be used for Lets Encrypt certificate registration"
  type        = string
}

variable "base_zone_name" {
  description = "The name of the Google Cloud DNS zone that already exists and is resolvable"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix that will be used to generate a unique domain from the base domain"
  type        = string
}

variable "project" {
  description = "The Google Cloud project to use"
  type        = string
}

variable "region" {
  description = "The GCP region where the resources will be deployed"
  default = "us-central1"
  type = string
}

variable "zone" {
  description = "The default GCP zone to use where applicable"
  default = "us-central1-b"
  type = string
}

variable "node_count" {
  type = number
  default = 5
}

variable "node_machine_type" {
  type = string
  default = "n1-standard-4"
}

variable "release_channel" {
  type = string
  default = "RAPID"
}