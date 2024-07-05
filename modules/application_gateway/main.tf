data "azurerm_key_vault_secret" "certificate" {
  for_each     = { for t in var.trusted_client_certificates : t.secret_name => t }
  name         = each.value.secret_name
  key_vault_id = each.value.key_vault_id
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones

  frontend_ip_configuration {
    name                 = "${var.name}-ip-conf"
    public_ip_address_id = var.public_ip_id
  }

  gateway_ip_configuration {
    name      = "${var.name}-subnet-configuration"
    subnet_id = var.subnet_id
  }

  dynamic "backend_address_pool" {
    for_each = var.backends
    iterator = backend
    content {
      name         = "${backend.key}-address-pool"
      fqdns        = backend.value.ip_addresses == null ? backend.value.fqdns : null
      ip_addresses = backend.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backends
    iterator = backend

    content {
      name                                = "${backend.key}-http-settings"
      port                                = backend.value.port
      host_name                           = backend.value.host
      protocol                            = backend.value.protocol
      path                                = ""
      affinity_cookie_name                = "ApplicationGatewayAffinity"
      probe_name                          = backend.value.probe_name
      request_timeout                     = backend.value.request_timeout
      pick_host_name_from_backend_address = backend.value.pick_host_name_from_backend
      cookie_based_affinity               = "Disabled"
    }
  }

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }

  dynamic "probe" {
    for_each = var.backends
    iterator = backend

    content {
      host                                      = backend.value.host
      path                                      = backend.value.probe
      protocol                                  = backend.value.protocol
      name                                      = "probe-${backend.key}"
      pick_host_name_from_backend_http_settings = backend.value.pick_host_name_from_backend
      minimum_servers                           = 0
      timeout                                   = 30
      interval                                  = 30
      unhealthy_threshold                       = 3

      match {
        status_code = ["200-399"]
      }
    }
  }

  dynamic "frontend_port" {
    for_each = distinct([for listener in values(var.listeners) : listener.port])

    content {
      name = "${var.name}-${frontend_port.value}-port"
      port = frontend_port.value
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.listeners
    iterator = listener

    content {
      name                = listener.value.certificate.name
      key_vault_secret_id = listener.value.certificate.id
    }
  }

  dynamic "ssl_profile" {
    for_each = var.ssl_profiles
    iterator = profile
    content {
      name                             = profile.value.name
      trusted_client_certificate_names = profile.value.trusted_client_certificate_names
      verify_client_cert_issuer_dn     = profile.value.verify_client_cert_issuer_dn
      ssl_policy {
        disabled_protocols   = profile.value.ssl_policy.disabled_protocols
        policy_type          = profile.value.ssl_policy.policy_type
        policy_name          = profile.value.ssl_policy.policy_name
        cipher_suites        = profile.value.ssl_policy.cipher_suites
        min_protocol_version = profile.value.ssl_policy.min_protocol_version
      }
    }
  }

  dynamic "trusted_client_certificate" {
    for_each = var.trusted_client_certificates
    iterator = i
    content {
      name = i.value.secret_name
      data = data.azurerm_key_vault_secret.client_cert[i.value.secret_name].value
    }
  }

  dynamic "http_listener" {
    for_each = var.listeners
    iterator = listener

    content {
      protocol                       = "Https"
      name                           = "${listener.key}-listener"
      frontend_ip_configuration_name = "${var.name}-ip-conf"
      frontend_port_name             = "${var.name}-${listener.value.port}-port"
      ssl_certificate_name           = listener.value.certificate.name
      host_name                      = listener.value.host
      ssl_profile_name               = listener.value.ssl_profile_name
      firewall_policy_id             = listener.value.firewall_policy_id
      require_sni                    = true
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routes_path_based
    iterator = route

    content {
      name               = "${route.key}-reqs-routing-rule-by-path"
      rule_type          = "PathBasedRouting"
      http_listener_name = "${route.value.listener}-listener"
      url_path_map_name  = "${route.value.url_map_name}-url-map"
      priority           = route.value.priority
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    iterator = path

    content {
      name                               = "${path.key}-url-map"
      default_backend_address_pool_name  = "${path.value.default_backend}-address-pool"
      default_backend_http_settings_name = "${path.value.default_backend}-http-settings"
      default_rewrite_rule_set_name      = path.value.default_rewrite_rule_set_name

      dynamic "path_rule" {
        for_each = path.value.path_rule
        iterator = path_rule

        content {
          name                       = path_rule.key
          paths                      = path_rule.value.paths
          rewrite_rule_set_name      = path_rule.value.rewrite_rule_set_name
          backend_address_pool_name  = "${path_rule.value.backend}-address-pool"
          backend_http_settings_name = "${path_rule.value.backend}-http-settings"
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routes
    iterator = route

    content {
      name                       = "${route.key}-reqs-routing-rule"
      rewrite_rule_set_name      = route.value.rewrite_rule_set_name
      priority                   = route.value.priority
      rule_type                  = "Basic"
      http_listener_name         = "${route.value.listener}-listener"
      backend_address_pool_name  = "${route.value.backend}-address-pool"
      backend_http_settings_name = "${route.value.backend}-http-settings"
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    iterator = rule_set
    content {
      name = rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rule_set.value.rewrite_rules
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.conditions
            iterator = condition
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configurations
            iterator = req_header
            content {
              header_name  = req_header.value.header_name
              header_value = req_header.value.header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configurations
            iterator = res_header
            content {
              header_name  = res_header.value.header_name
              header_value = res_header.value.header_value
            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value.url != null ? ["pass"] : []

            content {
              path         = rewrite_rule.value.url.path
              query_string = rewrite_rule.value.url.query_string
            }
          }
        }
      }

    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.identity_ids
  }

  ssl_policy {
    policy_type = "Custom"
    # this cipher suites are the defaults ones
    cipher_suites = [
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    ]
    min_protocol_version = "TLSv1_2"
  }

  dynamic "waf_configuration" {
    for_each = var.waf_enabled ? ["pass"] : []
    content {
      enabled                  = true
      firewall_mode            = "Detection"
      rule_set_type            = "OWASP"
      rule_set_version         = "3.1"
      request_body_check       = true
      file_upload_limit_mb     = 100
      max_request_body_size_kb = 128

      dynamic "disabled_rule_group" {
        for_each = var.waf_disabled_rule_group
        iterator = disabled_rule_group

        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }
    }
  }

  autoscale_configuration {
    min_capacity = var.app_gateway_min_capacity
    max_capacity = var.app_gateway_max_capacity
  }

  tags = var.tags
}
