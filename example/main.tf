

module "network" {
  source = "../"

  resource_group_name     = "your-rg"
  resource_group_location = "westeuropoe"
  vnet_name               = "your-vnet"
  address_spaces          = ["10.2.0.0/16"]
  subnet_prefixes         = ["10.2.0.0/19", "10.2.32.0/19", "10.2.64.0/19", "10.2.96.0/19"]
  subnet_names            = ["cluster", "database", "services", "public"]
  use_for_each            = false

  subnet_service_endpoints = {
    "cluster" : ["Microsoft.EventHub", "Microsoft.Storage", "Microsoft.ServiceBus"]
  }

  subnet_delegation = {
    "database" : [{
      name = "mysql-fs"
      service_delegation = {
        name    = "Microsoft.DBforMySQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
      }
    ]
  }
}
