resource "azuredevops_check_business_hours" "project" {
  project_id           = azuredevops_project.project.id
  display_name         = "Managed by Terraform"
  target_resource_id   = azuredevops_serviceendpoint_azurerm.project.id
  target_resource_type = "endpoint"
  start_time           = "07:00"
  end_time             = "15:30"
  time_zone            = "UTC"
  monday               = true
  tuesday              = true

  timeout = 1440
}