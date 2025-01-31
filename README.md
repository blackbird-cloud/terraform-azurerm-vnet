<!-- BEGIN_TF_DOCS -->
# Terraform Azurerm Vnet Module
Terraform module to create an Azure VNet

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Example
```hcl


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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnet_count](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_for_each](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space that is used by the virtual network. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_address_spaces"></a> [address\_spaces](#input\_address\_spaces) | The list of the address spaces that is used by the virtual network. | `list(string)` | `[]` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | The DNS servers to be used with vNet. | `list(string)` | `[]` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of an existing resource group to be imported. | `string` | n/a | yes |
| <a name="input_subnet_delegation"></a> [subnet\_delegation](#input\_subnet\_delegation) | `service_delegation` blocks for `azurerm_subnet` resource, subnet names as keys, list of delegation blocks as value, more details about delegation block could be found at the [document](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation). | <pre>map(list(object({<br/>    name = string<br/>    service_delegation = object({<br/>      name    = string<br/>      actions = optional(list(string))<br/>    })<br/>  })))</pre> | `{}` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | A list of public subnets inside the vNet. | `list(string)` | <pre>[<br/>  "subnet1"<br/>]</pre> | no |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | The address prefix to use for the subnet. | `list(string)` | <pre>[<br/>  "10.0.1.0/24"<br/>]</pre> | no |
| <a name="input_subnet_service_endpoints"></a> [subnet\_service\_endpoints](#input\_subnet\_service\_endpoints) | A map with key (string) `subnet name`, value (list(string)) to indicate enabled service endpoints on the subnet. Default value is []. | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with your network and subnets. | `map(string)` | <pre>{<br/>  "environment": "dev"<br/>}</pre> | no |
| <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled) | Whether enable tracing tags that generated by BridgeCrew Yor. | `bool` | `false` | no |
| <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix) | Default prefix for generated tracing tags | `string` | `"avm_"` | no |
| <a name="input_use_for_each"></a> [use\_for\_each](#input\_use\_for\_each) | Use `for_each` instead of `count` to create multiple resource instances. | `bool` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the vnet to create. | `string` | `"acctvnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | The address space of the newly created vNet |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The id of the newly created vNet |
| <a name="output_vnet_location"></a> [vnet\_location](#output\_vnet\_location) | The location of the newly created vNet |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the newly created vNet |
| <a name="output_vnet_subnets"></a> [vnet\_subnets](#output\_vnet\_subnets) | The subnets created inside the newly created vNet |
| <a name="output_vnet_subnets_ids"></a> [vnet\_subnets\_ids](#output\_vnet\_subnets\_ids) | The ids of subnets created inside the newly created vNet |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2025 [Blackbird Cloud](https://blackbird.cloud)
<!-- END_TF_DOCS -->