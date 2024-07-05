resource "random_password" "psql_password" {
  length           = 41
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "psql_password_ro" {
  length           = 41
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "postgresql_password" {
  name            = "${var.prefix}-psql-admin-password"
  value           = random_password.psql_password.result
  key_vault_id    = azurerm_key_vault.kvault.id
  content_type    = "password"
  expiration_date = "2028-12-31T00:00:00Z"
}

resource "azurerm_key_vault_secret" "postgresql_password_ro" {
  name            = "${var.prefix}-psql-admin-password"
  value           = random_password.psql_password_ro.result
  key_vault_id    = azurerm_key_vault.kvault.id
  content_type    = "password"
  expiration_date = "2028-12-31T00:00:00Z"
}

resource "azurerm_private_dns_zone" "database" {
  name                = "database.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "database" {
  name                  = "appdb.pagopa.tech.test.local"
  private_dns_zone_name = azurerm_private_dns_zone.database.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
  resource_group_name   = azurerm_resource_group.rg.name
  depends_on            = [azurerm_subnet.database]
}

resource "azurerm_postgresql_flexible_server" "database" {
  name                   = "${var.prefix}-flexdb"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "psqladminun"
  administrator_password = azurerm_key_vault_secret.postgresql_password.value

  sku_name   = "GP_Standard_D4s_v3"
  storage_mb = 32768
  version    = "12"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  delegated_subnet_id          = azurerm_subnet.database.id

  lifecycle {
    ignore_changes = [
      administrator_password,
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = "${var.prefix}-appdb"
  server_id = azurerm_postgresql_flexible_server.database.id
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "azurerm_postgresql_flexible_server_configuration" "readonly_permissions" {
  name      = "readonly_permissions"
  server_id = azurerm_postgresql_flexible_server.database.id
  value     = <<EOT
    CREATE USER rouser WITH PASSWORD '${azurerm_key_vault_secret.postgresql_password_ro.value}';
    GRANT CONNECT ON DATABASE appdb TO rouser;
    GRANT USAGE ON SCHEMA public TO rouser;
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO rouser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO rouser;
  EOT

  depends_on = [
    azurerm_postgresql_flexible_server_database.database,
  ]
}


resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.database.id
  value     = "on"
}

# PSQL Connection throttling
resource "azurerm_postgresql_flexible_server_configuration" "connection_throttling" {
  name      = "connection_throttling"
  server_id = azurerm_postgresql_flexible_server.database.id
  value     = "on"
}

# PSQL Log Checkpoints
resource "azurerm_postgresql_flexible_server_configuration" "log_checkpoints" {
  name      = "log_checkpoints"
  server_id = azurerm_postgresql_flexible_server.database.id
  value     = "on"
}

# Define Azure PostgreSQL Active Directory Administrator
resource "azurerm_postgresql_active_directory_administrator" "database" {
  server_name         = azurerm_postgresql_flexible_server.database.name
  resource_group_name = azurerm_resource_group.rg.name
  login               = "${var.prefix}-psqladadmin"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

# Create the PostgreSQL connection string
resource "azurerm_key_vault_secret" "psql_connection_string" {
  name            = "${var.prefix}-psql-connection-string"
  value           = "Host=${azurerm_postgresql_flexible_server.database.fqdn};Database=${azurerm_postgresql_flexible_server.database.name};Port=5432;User Id=${azurerm_postgresql_flexible_server.database.administrator_login}@${azurerm_postgresql_flexible_server.database.name};Password=${azurerm_key_vault_secret.postgresql_password.value};"
  key_vault_id    = azurerm_key_vault.kvault.id
  content_type    = "connection_string"
  expiration_date = "2028-12-31T00:00:00Z"
}

# Create the PostgreSQL connection string
resource "azurerm_key_vault_secret" "psql_connection_string_ro" {
  name            = "${var.prefix}-psql-connection-string-ro"
  value           = "Host=${azurerm_postgresql_flexible_server.database.fqdn};Database=${azurerm_postgresql_flexible_server.database.name};Port=5432;User Id=rouser@${azurerm_postgresql_flexible_server.database.name};Password=${azurerm_key_vault_secret.postgresql_password_ro.value};"
  key_vault_id    = azurerm_key_vault.kvault.id
  content_type    = "connection_string"
  expiration_date = "2028-12-31T00:00:00Z"
}