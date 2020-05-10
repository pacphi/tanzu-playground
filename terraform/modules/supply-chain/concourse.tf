resource "random_string" "concourse_user_password" {
  length  = 8
  special = false
}

data "template_file" "concourse_config" {
  template = file("${path.module}/templates/concourse-values.yml")

  vars = {
    concourse_domain = local.concourse_domain
    uaa_domain       = local.uaa_domain
    user_password    = random_string.concourse_user_password.result
  }
}

resource "helm_release" "concourse" {
  depends_on = [null_resource.uaa_blocker]

  name       = "concourse"
  namespace  = "concourse"
  repository = "https://concourse-charts.storage.googleapis.com/"
  chart      = "concourse"
  version    = "10.0.7"

  values = [data.template_file.concourse_config.rendered]

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

