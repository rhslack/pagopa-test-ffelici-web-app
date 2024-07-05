resource "azuredevops_environment" "project" {
  project_id = azuredevops_project.project.id
  name       = "project-environment"
}

resource "azuredevops_check_approval" "project" {
  project_id           = azuredevops_project.project.id
  target_resource_id   = azuredevops_environment.project.id
  target_resource_type = "environment"

  requester_can_approve = false
  approvers = [
    azuredevops_group.project.origin_id,
  ]

  timeout = 43200
}