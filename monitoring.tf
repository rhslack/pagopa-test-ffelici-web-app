# Enable diagnostics for the PostgreSQL server
resource "azurerm_monitor_diagnostic_setting" "psql_diagnostics" {
  name                       = "psql-diagnostics"
  target_resource_id         = azurerm_postgresql_flexible_server.database.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "PostgreSQLLogs"

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}

# Create a Log Analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-analytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Define Azure Application Insights
resource "azurerm_application_insights" "main" {
  name                = "appinsights-1234"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}