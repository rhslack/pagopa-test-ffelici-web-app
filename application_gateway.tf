
resource "azurerm_public_ip" "app_gw_public_ip" {
  name                = "pagopa-tech-test-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

## user assined identity: (application gateway) ##
resource "azurerm_user_assigned_identity" "appgateway" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "pagopa-tech-test-appgateway-identity"

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "app_gateway_policy" {
  depends_on = [
    azurerm_key_vault.kvault
  ]

  key_vault_id            = azurerm_key_vault.kvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.appgateway.principal_id
  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}


module "app_gw" {

  depends_on = [
    azurerm_subnet.application_gateway,
  ]

  count = var.app_gateway_is_enabled ? 1 : 0

  source = "./modules/application_gateway"

  name                = "pagopa-tech-test-app-gw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # SKU
  sku_name = var.app_gateway_sku_name
  sku_tier = var.app_gateway_sku_tier

  # WAF
  waf_enabled = var.app_gateway_waf_enabled

  # Networking
  subnet_id    = azurerm_subnet.application_gateway.id
  public_ip_id = azurerm_public_ip.app_gw_public_ip.id

  # Configure backends
  backends = {

    apim = {
      protocol                    = "Https"
      host                        = replace(azurerm_api_management.apim.gateway_url, "https://", "")
      port                        = 443
      ip_addresses                = null
      probe                       = "/status-0123456789abcdef"
      probe_name                  = "probe-apim"
      fqdns                       = [replace(azurerm_api_management.apim.gateway_url, "https://", "")]
      pick_host_name_from_backend = false
      request_timeout             = 10
    }

    portal = {
      protocol                    = "Https"
      host                        = replace(azurerm_api_management.apim.portal_url, "https://", "")
      port                        = 443
      ip_addresses                = null
      probe                       = "/signin"
      probe_name                  = "probe-portal"
      fqdns                       = [replace(azurerm_api_management.apim.portal_url, "https://", "")]
      pick_host_name_from_backend = false
      request_timeout             = 10
    }

    management = {
      protocol                    = "Https"
      host                        = replace(azurerm_api_management.apim.management_api_url, "https://", "")
      port                        = 443
      ip_addresses                = null
      probe                       = "/ServiceStatus"
      probe_name                  = "probe-management"
      fqdns                       = [replace(azurerm_api_management.apim.management_api_url, "https://", "")]
      pick_host_name_from_backend = false
      request_timeout             = 10
    }
  }

  ssl_profiles = [{
    name                             = "${var.prefix}-ssl-profile"
    trusted_client_certificate_names = null
    verify_client_cert_issuer_dn     = false
    ssl_policy = {
      disabled_protocols = []
      policy_type        = "Custom"
      policy_name        = "" # with Custom type set empty policy_name (not required by the provider)
      cipher_suites = [
        "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
        "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
        "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
        "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
      ]
      min_protocol_version = "TLSv1_2"
    }
  }]


  trusted_client_certificates = []
  listeners = {
    api = {
      protocol           = "Https"
      host               = "api.${var.prefix}.${var.external_domain}"
      port               = 443
      ssl_profile_name   = "${var.prefix}-ssl-profile"
      firewall_policy_id = null
      certificate = {
        name = azurerm_key_vault_certificate.certificate_api.name
        id = trimsuffix(
          azurerm_key_vault_certificate.certificate_api.secret_id,
          azurerm_key_vault_certificate.certificate_api.version
        )
      }
    }

    portal = {
      protocol           = "Https"
      host               = "portal.${var.prefix}.${var.external_domain}"
      port               = 443
      ssl_profile_name   = "${var.prefix}-ssl-profile"
      firewall_policy_id = null
      certificate = {
        name = azurerm_key_vault_certificate.certificate_portal.name
        id = trimsuffix(
          azurerm_key_vault_certificate.certificate_portal.secret_id,
          azurerm_key_vault_certificate.certificate_portal.version
        )
      }
    }

    management = {
      protocol           = "Https"
      host               = "management.${var.prefix}.${var.external_domain}"
      port               = 443
      ssl_profile_name   = "${var.prefix}-ssl-profile"
      firewall_policy_id = null
      certificate = {
        name = azurerm_key_vault_certificate.certificate_management.name
        id = trimsuffix(
          azurerm_key_vault_certificate.certificate_management.secret_id,
          azurerm_key_vault_certificate.certificate_management.version
        )
      }
    }
  }

  # maps listener to backend
  routes = {
    api = {
      listener              = "api"
      backend               = "apim"
      rewrite_rule_set_name = "rewrite-rule-set"
      priority              = 1
    }

    portal = {
      listener              = "portal"
      backend               = "portal"
      rewrite_rule_set_name = "rewrite-rule-set"
      priority              = 20
    }

    management = {
      listener              = "management"
      backend               = "management"
      rewrite_rule_set_name = "rewrite-rule-set"
      priority              = 50
    }
  }


  rewrite_rule_sets = [
    {
      name = "rewrite-rule-set"
      rewrite_rules = [{
        name          = "http-headers-api"
        rule_sequence = 100
        conditions    = []
        request_header_configurations = [
          {
            header_name  = "X-Forwarded-For"
            header_value = "{var_client_ip}"
          },
          {
            header_name  = "X-Client-Ip"
            header_value = "{var_client_ip}"
          },
        ]
        response_header_configurations = []
        url                            = null
      }]
    },
  ]

  # TLS
  identity_ids = [azurerm_user_assigned_identity.appgateway.id]

  # Scaling
  app_gateway_min_capacity = var.app_gateway_min_capacity
  app_gateway_max_capacity = var.app_gateway_max_capacity

  alerts_enabled = false

  url_path_map = {}

  tags = var.tags
}