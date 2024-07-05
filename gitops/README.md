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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 0.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project-description"></a> [project-description](#input\_project-description) | The description of the project | `string` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | The name of the project | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
