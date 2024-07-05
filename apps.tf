resource "azurerm_service_plan" "app-service-fe-plan" {
  name                = "${var.prefix}-fe-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_frontend_sku
}


resource "azurerm_linux_web_app" "frontend" {
  name                = "${var.prefix}-node-fe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app-service-fe-plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  connection_string {
    name  = "PSQL_Connection_ro"
    value = azurerm_key_vault_secret.psql_connection_string_ro.id
    type  = "Custom"
  }
}


resource "azurerm_service_plan" "app-service-be-plan" {
  name                = "${var.prefix}-be-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_backend_sku
}


resource "azurerm_linux_web_app" "backend-transaction" {
  name                = "${var.prefix}-node-be"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app-service-be-plan.id

  site_config {
    application_stack {
      docker_image     = "golang"
      docker_image_tag = "1.18"
    }
  }

  connection_string {
    name  = "PSQL_Connection"
    value = azurerm_key_vault_secret.psql_connection_string.id
    type  = "Custom"
  }
}

resource "azurerm_linux_function_app" "backend-core" {
  name                       = "${var.prefix}-function-be"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.app-service-be-plan.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  site_config {
    application_stack {
      docker {
        registry_url = "registry.hub.docker.com"
        image_name   = "golang"
        image_tag    = "1.18"
      }
    }
  }
}
