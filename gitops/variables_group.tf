resource "azuredevops_variable_group" "project" {
  project_id   = azuredevops_project.project.id
  name         = "Terraform_SPN"
  description  = "Service Principal credentials for Terraform deployment pipelin"
  allow_access = true

  variable {
    name  = "ARM_CLIENT_ID"
    value = data.azurerm_client_config.current.client_id
  }

  variable {
    name         = "ARM_CLIENT_SECRET"
    secret_value = azuread_application_password.project.value
    is_secret    = true
  }

  variable {
    name  = "ARM_SUBSCRIPTION_ID"
    value = data.azurerm_client_config.current.subscription_id
  }

  variable {
    name  = "ARM_TENANT_ID"
    value = data.azurerm_client_config.current.tenant_id
  }
}