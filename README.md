# pagopa-test-ffelici-web-app

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.52.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.52.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_gw"></a> [app\_gw](#module\_app\_gw) | ./modules/application_gateway | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/api_management) | resource |
| [azurerm_api_management_custom_domain.api_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/api_management_custom_domain) | resource |
| [azurerm_dns_a_record.dns_a_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_management](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_portal](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault.kvault](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.apim_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.app_gateway_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.certificate_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.certificate_management](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.certificate_portal](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.postgresql_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.postgresql_password_ro](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.psql_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.psql_connection_string_ro](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_function_app.backend-core](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/linux_function_app) | resource |
| [azurerm_linux_web_app.backend-transaction](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app.frontend](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/linux_web_app) | resource |
| [azurerm_monitor_autoscale_setting.backend](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_monitor_autoscale_setting.frontends](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_postgresql_active_directory_administrator.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.connection_throttling](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.log_checkpoints](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.log_connections](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_configuration.readonly_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_private_dns_zone.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.app_gw_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/resource_group) | resource |
| [azurerm_service_plan.app-service-be-plan](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/service_plan) | resource |
| [azurerm_service_plan.app-service-fe-plan](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/service_plan) | resource |
| [azurerm_storage_account.functions](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/storage_account) | resource |
| [azurerm_subnet.application_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/subnet) | resource |
| [azurerm_subnet.backend](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/subnet) | resource |
| [azurerm_subnet.database](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/subnet) | resource |
| [azurerm_subnet.frontend](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.appgateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.vnet-app](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.vnet-hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.hub-spoke](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.spoke-hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/resources/virtual_network_peering) | resource |
| [random_password.psql_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [random_password.psql_password_ro](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.52.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_backend_sku"></a> [app\_backend\_sku](#input\_app\_backend\_sku) | (Required) The SKU for beckend the plan. | `string` | `"B1"` | no |
| <a name="input_app_frontend_sku"></a> [app\_frontend\_sku](#input\_app\_frontend\_sku) | (Required) The SKU for frontend the plan. | `string` | `"B1"` | no |
| <a name="input_app_gateway_is_enabled"></a> [app\_gateway\_is\_enabled](#input\_app\_gateway\_is\_enabled) | (Optional) Enable the App Gateway to be deployed. | `bool` | n/a | yes |
| <a name="input_app_gateway_max_capacity"></a> [app\_gateway\_max\_capacity](#input\_app\_gateway\_max\_capacity) | (Optional) Maximum capacity for autoscaling. Accepted values are in the range 2 to 125. | `string` | `"3"` | no |
| <a name="input_app_gateway_min_capacity"></a> [app\_gateway\_min\_capacity](#input\_app\_gateway\_min\_capacity) | (Required) Minimum capacity for autoscaling. Accepted values are in the range 0 to 100. | `string` | `"1"` | no |
| <a name="input_app_gateway_sku_name"></a> [app\_gateway\_sku\_name](#input\_app\_gateway\_sku\_name) | Application Gateway SKU name | `string` | n/a | yes |
| <a name="input_app_gateway_sku_tier"></a> [app\_gateway\_sku\_tier](#input\_app\_gateway\_sku\_tier) | Application Gateway SKU tier | `string` | n/a | yes |
| <a name="input_app_gateway_waf_enabled"></a> [app\_gateway\_waf\_enabled](#input\_app\_gateway\_waf\_enabled) | (Optional) Enable the WAF the App Gateway. | `bool` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Dns external domain for the resources that will be created | `string` | `"test"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where the API Management Service exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"Prefix for the resources that will be created"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the API Management Service should be exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) The tags associated on this deployment. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
