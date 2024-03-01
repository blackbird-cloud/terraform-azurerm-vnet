resource "azurerm_virtual_network" "vnet" {
  address_space       = length(var.address_spaces) == 0 ? [var.address_space] : var.address_spaces
  location            = var.resource_group_location
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = var.tags
}

locals {
  subnet_names_prefixes_map = zipmap(var.subnet_names, var.subnet_prefixes)
}

resource "azurerm_subnet" "subnet_count" {
  count = var.use_for_each ? 0 : length(var.subnet_names)

  address_prefixes     = [var.subnet_prefixes[count.index]]
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], [])

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], [])

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

resource "azurerm_subnet" "subnet_for_each" {
  for_each = var.use_for_each ? toset(var.subnet_names) : []

  address_prefixes     = [local.subnet_names_prefixes_map[each.value]]
  name                 = each.value
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = lookup(var.subnet_service_endpoints, each.value, [])

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, each.value, [])

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

locals {
  azurerm_subnets = var.use_for_each ? [for s in azurerm_subnet.subnet_for_each : s] : [for s in azurerm_subnet.subnet_count : s]
}
