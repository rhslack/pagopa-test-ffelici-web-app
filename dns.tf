resource "azurerm_dns_zone" "public" {
  name                = join(".", [var.prefix, var.external_domain])
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

# application gateway records
resource "azurerm_dns_a_record" "dns_a_api" {
  name                = "api"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = "3600"
  records             = [resource.azurerm_public_ip.app_gw_public_ip.ip_address]
  tags                = var.tags
}

resource "azurerm_dns_a_record" "dns_a_portal" {
  name                = "portal"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = "3600"
  records             = [resource.azurerm_public_ip.app_gw_public_ip.ip_address]
  tags                = var.tags
}

resource "azurerm_dns_a_record" "dns_a_management" {
  name                = "management"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = "3600"
  records             = [resource.azurerm_public_ip.app_gw_public_ip.ip_address]
  tags                = var.tags
}
