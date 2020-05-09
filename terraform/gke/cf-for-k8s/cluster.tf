data "google_client_config" "current" {}

locals {
  full_environment_prefix = "tanzu-gke-cf-${var.environment_name}"
}

resource "google_container_cluster" "default" {
  provider = google-beta
  name = local.full_environment_prefix
  location = var.zone
  initial_node_count = var.node_count

  release_channel {
    channel = var.release_channel
  }

  maintenance_policy {
    recurring_window {
        start_time = "2019-01-01T00:00:00-07:00"
        end_time = "2019-01-01T06:00:00-07:00"
        recurrence = "FREQ=DAILY"
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled = true
  }

  node_config {
    image_type = "UBUNTU"
    machine_type = var.node_machine_type

    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    labels = {
      "cluster_management_overload_env_name" = var.environment_name
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  // Wait for cluster to stabilize
  provisioner "local-exec" {
    command = "sleep 90"
  }

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}

resource "null_resource" "cluster_blocker" {
  depends_on = [google_container_cluster.default]
}
