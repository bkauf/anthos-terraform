data "azurerm_subscription" "current" {
}

resource "azuread_application" "aad_app" {
  #name                       = var.application_name    
  display_name               = var.application_name
  #available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource azuread_service_principal "aad_app" {
  application_id               = azuread_application.aad_app.application_id
  app_role_assignment_required = false
}

# controlplane.createRoleAssignmentForProxyConfigKeyVaultNode requires service
# principal to have permission for role assignment.

resource "azurerm_role_assignment" "user_access_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.aad_app.object_id
}