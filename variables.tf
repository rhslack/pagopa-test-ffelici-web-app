variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which the API Management Service should be exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the API Management Service exists. Changing this forces a new resource to be created."
}

variable "prefix" {
  type    = string
  default = "Prefix for the resources that will be created"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The tags associated on this deployment."
  default     = {}
}

# DNS Parameters
variable "external_domain" {
  type        = string
  description = "Dns external domain for the resources that will be created"
  default     = "test"
}

# Applcation Gateway vars
variable "app_gateway_is_enabled" {
  type        = bool
  description = "(Optional) Enable the App Gateway to be deployed."
}

variable "app_gateway_waf_enabled" {
  type        = bool
  description = "(Optional) Enable the WAF the App Gateway."
}

variable "app_gateway_sku_name" {
  type        = string
  description = "Application Gateway SKU name"
}

variable "app_gateway_sku_tier" {
  type        = string
  description = "Application Gateway SKU tier"
}

variable "app_gateway_max_capacity" {
  type        = string
  description = "(Optional) Maximum capacity for autoscaling. Accepted values are in the range 2 to 125."
  default     = "3"
}

variable "app_gateway_min_capacity" {
  type        = string
  description = "(Required) Minimum capacity for autoscaling. Accepted values are in the range 0 to 100."
  default     = "1"
}

# App service parameters

variable "app_frontend_sku" {
  type        = string
  description = "(Required) The SKU for frontend the plan."
  default     = "B1"
}

variable "app_backend_sku" {
  type        = string
  description = "(Required) The SKU for beckend the plan."
  default     = "B1"
}