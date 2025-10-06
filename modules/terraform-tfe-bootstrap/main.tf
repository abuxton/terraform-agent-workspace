locals {
  backend_content = templatefile("${path.module}/template/cloud-backend.tpl", {
    hostname     = var.tfe_hostname
    organization = var.tfe_organization
    workspace    = var.tfe_workspace_name
    project      = var.tfe_project
    tags         = length(var.tfe_workspace_tags) > 0 ? jsonencode(var.tfe_workspace_tags) : ""
  })
}

resource "local_file" "cloud_backend" {
  content         = local.backend_content
  filename        = "${path.module}/backend.tf"
  file_permission = "0644"
}
