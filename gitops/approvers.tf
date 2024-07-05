locals {
  azure_approvers = [
    "fabio.felici96c@outlook.com",
    # This is an example, add user here to grant approval permissions
  ]
}

data "azuredevops_users" "users" {
  for_each       = toset(local.azure_approvers)
  principal_name = each.value
}

resource "azuredevops_group" "project" {
  scope        = azuredevops_project.project.id
  display_name = "Approvers Team"
  description  = "Team that can approve the apply on infrastructure env"
}

resource "azuredevops_group_membership" "approvers_membership" {
  for_each = data.azuredevops_users.users
  group    = azuredevops_group.project.descriptor
  members  = [for user in each.value.users : user.descriptor]
}
