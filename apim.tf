locals {
  api_domain        = "api.${var.prefix}.${var.external_domain}"
  portal_domain     = "portal.${var.prefix}.${var.external_domain}"
  management_domain = "management.${var.prefix}.${var.external_domain}"
}


resource "azurerm_api_management" "apim" {
  depends_on = [
    azurerm_key_vault_access_policy.apim_policy
  ]
  name                = "pagopa-tech-test-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Test Tech"
  publisher_email     = "test-tech-pago@terraform.io"
  # TLS
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.apim.id]
  }

  policy {
    xml_content = templatefile("./templates/base_policy.tpl", {
      portal-domain         = "portal.${var.prefix}.${var.external_domain}"
      management-api-domain = "management.${var.prefix}.${var.external_domain}"
      apim-name             = "apim.${var.prefix}.${var.external_domain}"
    })
  }

  sku_name = "Developer_1"
}

## user assined identity: (application gateway) ##
resource "azurerm_user_assigned_identity" "apim" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "pagopa-tech-test-apim-identity"

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "apim_policy" {
  depends_on = [
    azurerm_key_vault.kvault,
  ]

  key_vault_id       = azurerm_key_vault.kvault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.apim.principal_id
  key_permissions    = ["Get", "List"]
  secret_permissions = ["Get", "List"]
  certificate_permissions = [
    "Get",
    "List",
    "ListIssuers",
    "Import",
    "ManageContacts",
    "ManageIssuers",
    "GetIssuers",
  ]
  storage_permissions = []
}


resource "azurerm_api_management_custom_domain" "api_custom_domain" {

  api_management_id = azurerm_api_management.apim.id

  gateway {
    host_name = local.api_domain
    key_vault_id = trimsuffix(
      azurerm_key_vault_certificate.certificate_api.secret_id,
      azurerm_key_vault_certificate.certificate_api.version
    )
    ssl_keyvault_identity_client_id = azurerm_user_assigned_identity.apim.client_id
  }

  developer_portal {
    host_name = local.portal_domain
    key_vault_id = trimsuffix(
      azurerm_key_vault_certificate.certificate_portal.secret_id,
      azurerm_key_vault_certificate.certificate_portal.version
    )
    ssl_keyvault_identity_client_id = azurerm_user_assigned_identity.apim.client_id
  }

  management {
    host_name = local.management_domain
    key_vault_id = trimsuffix(
      azurerm_key_vault_certificate.certificate_management.secret_id,
      azurerm_key_vault_certificate.certificate_management.version
    )
    ssl_keyvault_identity_client_id = azurerm_user_assigned_identity.apim.client_id
  }
}
