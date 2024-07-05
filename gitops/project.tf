resource "azuredevops_project" "project" {
  name               = var.project-name
  description        = var.project-description
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  features = {
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "repositories" = "disabled"
    "boards"       = "disabled"
  }
}


resource "azuredevops_serviceendpoint_azurerm" "project" {
  project_id                             = azuredevops_project.project.id
  service_endpoint_name                  = "pagopa-test-ffelici-web-app-service-connection"
  description                            = "Connection to Azure for deployment"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  credentials {
    serviceprincipalid = data.azurerm_client_config.current.client_id
  }
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = "Azure subscription 1"
}


data "azuredevops_git_repository" "project" {
  project_id = azuredevops_project.project.id
  name       = "pagopa-test-ffelici-web-app"
}

resource "azuredevops_build_definition" "project" {
  project_id = azuredevops_project.project.id
  name       = "pagopa-test-ffelici-web-app-pipeline"
  path       = "\\"
  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repository.project.id
    branch_name = "refs/heads/main"
    yml_path    = "azure-pipelines.yml"
  }
  ci_trigger {
    use_yaml = true
  }
}
