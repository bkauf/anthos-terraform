
data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "vnet" {
  name     = var.vnet_resource_group
  location = var.region

}

#Create VNet

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.region
 resource_group_name = "${azurerm_resource_group.vnet.name}"
  address_space       = ["10.0.0.0/16", "10.200.0.0/16"]
}

#Create subnet
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.vnet.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

#Create Public IP
resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "nat-gateway-pip"
  location            = var.region
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Create NAT Gateway

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.name}-nat-gateway"
  location                = var.region
  resource_group_name     = "${azurerm_resource_group.vnet.name}"
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

# associate public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_gateway" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

# associate  NAT Gateway with subnet
resource "azurerm_subnet_nat_gateway_association" "default_subnet_nat_association" {
  subnet_id      = "${azurerm_subnet.default.id}"
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_role_definition" "this" {
  name        = "${var.aad_app_name}-role-admin"
  scope       = data.azurerm_subscription.current.id
  description = "Allow Anthos service to manage role definitions."

  permissions {
    actions = [
      "Microsoft.Authorization/roleDefinitions/read",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",
    ]
    not_actions = [
    ]
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "this" {
  scope                = "${azurerm_resource_group.vnet.id}"
  role_definition_name = "${azurerm_role_definition.this.name}"
  principal_id         = var.sp_obj_id

}

resource "azurerm_role_definition" "vnet" {
  name        = "${var.aad_app_name}-vnet-admin"
  scope       = data.azurerm_subscription.current.id
  description = "Allow Anthos service to use and manage virtual network and role assignments"

  permissions {
    actions = [
      "*/read",
      "Microsoft.Network/*/join/action",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
    ]
    not_actions = [
    ]
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id ,
  ]
}

resource "azurerm_role_assignment" "aad_app_vnet" {
  scope                = "${azurerm_virtual_network.vnet.id}"
  role_definition_name = "${azurerm_role_definition.vnet.name}"
  principal_id         = var.sp_obj_id
}