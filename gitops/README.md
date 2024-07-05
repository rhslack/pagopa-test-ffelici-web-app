# Azure DevOps Project setup

Set the two environment variables. For more details, see the [README](https://github.com/microsoft/terraform-provider-azuredevops#terraform-provider-for-azure-devops-devops-resource-manager). 
AZDO_PERSONAL_ACCESS_TOKEN and AZDO_ORG_SERVICE_URL. If you use bash, you can try this.

```bash
export AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/<Your Org Name>
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=0.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 1.1.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application_password.project](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_application_registration.project](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_registration) | resource |
| [azuredevops_build_definition.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/build_definition) | resource |
| [azuredevops_check_approval.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/check_approval) | resource |
| [azuredevops_check_business_hours.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/check_business_hours) | resource |
| [azuredevops_environment.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment) | resource |
| [azuredevops_group.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group) | resource |
| [azuredevops_group_membership.approvers_membership](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group_membership) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |
| [azuredevops_serviceendpoint_azurerm.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_github.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_variable_group.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/variable_group) | resource |
| [azuredevops_users.users](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/users) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_access_token"></a> [github\_access\_token](#input\_github\_access\_token) | The github token ( passed by ENV TF\_VAR\_github\_access\_token ) | `string` | n/a | yes |
| <a name="input_project-description"></a> [project-description](#input\_project-description) | The description of the project | `string` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | The name of the project | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
