resource "azuread_application_registration" "project" {
  display_name = "pagopa-test-ffelici-web-app"
}

resource "azuread_application_password" "project" {
  display_name   = "ado_pass"
  application_id = azuread_application_registration.project.id
}