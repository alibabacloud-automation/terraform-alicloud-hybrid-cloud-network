Terraform module to build hybrid cloud/multi-cloud network for Alibaba Cloud

terraform-alicloud-hybrid-cloud-network
======================================

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/blob/main/README-CN.md)

This Module focuses on scenarios where it is necessary to orchestrate business collaboration across on-premises and cloud environments or across multiple clouds. We will explore how to leverage direct physical lines and Alibaba Cloud's networking products to rapidly construct a secure, stable, and elastic network for hybrid/multi-cloud collaboration. This is intended to facilitate and satisfy our clients’ cloud adoption journey.

Operational Workflow Overview:

1. Establish connectivity between IDC/third-party cloud providers and Alibaba Cloud's Direct Connect endpoints using physical dedicated lines.
2. Based on the dedicated connection, create Virtual Border Routers (VBRs) on demand, ensuring logical isolation between different VBRs.
3. Enable high-speed channel connectivity between the VBR and cloud-based Virtual Private Clouds (VPCs) through the Transit Router (TR), allowing secure and stable interconnectivity between multi-regional VPCs and IDCs or third-party cloud resources spread across various locations.
4. Finalize the configuration of VPCs, Virtual Switches (VSWs), VBRs, TRs, etc., to ensure network integration is complete.

Architecture Diagram:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/main/scripts/diagram.png)

## Usage

create VPC and VBR resources in one region.

```hcl
data "alicloud_express_connect_physical_connections" "example" {
  name_regex = "^preserved-NODELETING"
}

module "this" {
  source = "alibabacloud-automation/hybrid-cloud-network/alicloud"

  vbr_config = [
    {
      vbr = {
        physical_connection_id = data.alicloud_express_connect_physical_connections.example.connections[0].id
        vlan_id                = 104
        local_gateway_ip       = "192.168.0.1"
        peer_gateway_ip        = "192.168.0.2"
        peering_subnet_mask    = "255.255.255.252"
      },
      vbr_bgp_group = {
        peer_asn = 45000
      },
    },
  ]

  vpc_config = [
    {
      vpc = {
        cidr_block = "10.0.0.0/16"
      },
      vswitches = [
        {
          zone_id    = "cn-beijing-i"
          cidr_block = "10.0.1.0/24"
        },
        {
          zone_id    = "cn-beijing-j"
          cidr_block = "10.0.2.0/24"
        }
      ],
    },
  ]
}
```

create VBR in cn-hangzhou and create VPC and VSwitch resources in cn-beijing.

```hcl
provider "alicloud" {
  region = "cn-hangzhou"
  alias  = "hz"
}

data "alicloud_express_connect_physical_connections" "example" {
  provider   = alicloud.hz
  name_regex = "^preserved-NODELETING"
}

module "hz" {
  source = "alibabacloud-automation/hybrid-cloud-network/alicloud"
  providers = {
    alicloud = alicloud.hz
  }

  vbr_config = [
    {
      vbr = {
        physical_connection_id = data.alicloud_express_connect_physical_connections.example.connections[0].id
        vlan_id                = 104
        local_gateway_ip       = "192.168.0.1"
        peer_gateway_ip        = "192.168.0.2"
        peering_subnet_mask    = "255.255.255.252"
      },
      vbr_bgp_group = {
        peer_asn = 45000
      },
    },
  ]

  create_vpc_resources = false
}

provider "alicloud" {
  region = "cn-beijing"
  alias  = "bj"
}

module "bj" {
  source = "alibabacloud-automation/hybrid-cloud-network/alicloud"
  providers = {
    alicloud = alicloud.bj
  }

  create_cen_instance = false
  cen_instance_id     = module.hz.cen_instance_id

  create_vbr_resources = false

  vpc_config = [
    {
      vpc = {
        cidr_block = "10.0.0.0/16"
      },
      vswitches = [
        {
          zone_id    = "cn-beijing-i"
          cidr_block = "10.0.1.0/24"
        },
        {
          zone_id    = "cn-beijing-j"
          cidr_block = "10.0.2.0/24"
        }
      ],
    },
  ]
}
```

## Examples

* [Basic Example](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/tree/main/examples/basic)
* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >=1.229.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >=1.229.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vbr"></a> [vbr](#module\_vbr) | ./modules/vbr | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_transit_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    cen_instance_name = optional(string, null)<br>    protection_level  = optional(string, "REDUCED")<br>    description       = optional(string, null)<br>    tags              = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_cen_instance_id"></a> [cen\_instance\_id](#input\_cen\_instance\_id) | The id of an exsiting cen instance. | `string` | `null` | no |
| <a name="input_cen_transit_router_id"></a> [cen\_transit\_router\_id](#input\_cen\_transit\_router\_id) | The transit router id of an existing transit router. | `string` | `null` | no |
| <a name="input_create_cen_instance"></a> [create\_cen\_instance](#input\_create\_cen\_instance) | Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen\_instance\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_cen_transit_router"></a> [create\_cen\_transit\_router](#input\_create\_cen\_transit\_router) | Whether to create transit router. If false, you can specify an existing transit router by setting 'cen\_transit\_router\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vbr_resources"></a> [create\_vbr\_resources](#input\_create\_vbr\_resources) | Whether to create vbr resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vpc_resources"></a> [create\_vpc\_resources](#input\_create\_vpc\_resources) | Whether to create vpc resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_tr_config"></a> [tr\_config](#input\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, null)<br>    transit_router_description = optional(string, null)<br>    support_multicast          = optional(string, null)<br>    tags                       = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_vbr_config"></a> [vbr\_config](#input\_vbr\_config) | The list parameters of vbr resources. The attributes 'vbr', 'vbr\_bgp\_group' are required. | <pre>list(object({<br>    vbr = object({<br>      physical_connection_id     = string<br>      vlan_id                    = number<br>      local_gateway_ip           = string<br>      peer_gateway_ip            = string<br>      peering_subnet_mask        = string<br>      virtual_border_router_name = optional(string, null)<br>      description                = optional(string, null)<br>    })<br>    tr_vbr_attachment = optional(object({<br>      transit_router_attachment_name        = optional(string, null)<br>      transit_router_attachment_description = optional(string, null)<br>      tags                                  = optional(map(string), {})<br>      auto_publish_route_enabled            = optional(bool, true)<br>      route_table_propagation_enabled       = optional(bool, true)<br>      route_table_association_enabled       = optional(bool, true)<br>    }), {})<br>    vbr_health_check = optional(object({<br>      create_vbr_health_check = optional(bool, true)<br>      health_check_interval   = optional(number, 2)<br>      healthy_threshold       = optional(number, 8)<br>    }), {})<br>    vbr_bgp_group = object({<br>      peer_asn       = string<br>      auth_key       = optional(string, null)<br>      bgp_group_name = optional(string, null)<br>      description    = optional(string, null)<br>      is_fake_asn    = optional(bool, false)<br>    })<br>    vbr_bgp_peer = optional(object({<br>      bfd_multi_hop   = optional(number, 255)<br>      enable_bfd      = optional(bool, "false")<br>      ip_version      = optional(string, "IPV4")<br>      peer_ip_address = optional(string, null)<br>    }), {})<br>  }))</pre> | <pre>[<br>  {<br>    "vbr": {<br>      "local_gateway_ip": null,<br>      "peer_gateway_ip": null,<br>      "peering_subnet_mask": null,<br>      "physical_connection_id": null,<br>      "vlan_id": null<br>    },<br>    "vbr_bgp_group": {<br>      "peer_asn": null<br>    }<br>  }<br>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = map(string)<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_group_id"></a> [bgp\_group\_id](#output\_bgp\_group\_id) | The id of BGP group. |
| <a name="output_bgp_group_status"></a> [bgp\_group\_status](#output\_bgp\_group\_status) | The status of BGP group. |
| <a name="output_bgp_peer_id"></a> [bgp\_peer\_id](#output\_bgp\_peer\_id) | The id of BGP peer. |
| <a name="output_bgp_peer_name"></a> [bgp\_peer\_name](#output\_bgp\_peer\_name) | The name of BGP peer. |
| <a name="output_bgp_peer_status"></a> [bgp\_peer\_status](#output\_bgp\_peer\_status) | The status of BGP peer. |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_cen_instance_status"></a> [cen\_instance\_status](#output\_cen\_instance\_status) | The status of CEN instance. |
| <a name="output_cen_transit_router_id"></a> [cen\_transit\_router\_id](#output\_cen\_transit\_router\_id) | The id of CEN transit router. |
| <a name="output_cen_transit_router_support_multicast"></a> [cen\_transit\_router\_support\_multicast](#output\_cen\_transit\_router\_support\_multicast) | The status of CEN transit router. |
| <a name="output_cen_transit_router_type"></a> [cen\_transit\_router\_type](#output\_cen\_transit\_router\_type) | The type of CEN transit router. |
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | The id of health check. |
| <a name="output_tr_vbr_attachment_id"></a> [tr\_vbr\_attachment\_id](#output\_tr\_vbr\_attachment\_id) | The id of attachment bewteen TR and VBR. |
| <a name="output_tr_vbr_attachment_status"></a> [tr\_vbr\_attachment\_status](#output\_tr\_vbr\_attachment\_status) | The status of attachment bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_association_id"></a> [tr\_vbr\_route\_table\_association\_id](#output\_tr\_vbr\_route\_table\_association\_id) | The id of route table association bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_association_status"></a> [tr\_vbr\_route\_table\_association\_status](#output\_tr\_vbr\_route\_table\_association\_status) | The status of route table association bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_propagation_id"></a> [tr\_vbr\_route\_table\_propagation\_id](#output\_tr\_vbr\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_propagation_status"></a> [tr\_vbr\_route\_table\_propagation\_status](#output\_tr\_vbr\_route\_table\_propagation\_status) | The status of route table propagation bewteen TR and VBR. |
| <a name="output_tr_vpc_attachment_id"></a> [tr\_vpc\_attachment\_id](#output\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC. |
| <a name="output_tr_vpc_attachment_status"></a> [tr\_vpc\_attachment\_status](#output\_tr\_vpc\_attachment\_status) | The status of attachment between TR and VPC. |
| <a name="output_tr_vpc_route_table_association_id"></a> [tr\_vpc\_route\_table\_association\_id](#output\_tr\_vpc\_route\_table\_association\_id) | The id of route table association bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_association_status"></a> [tr\_vpc\_route\_table\_association\_status](#output\_tr\_vpc\_route\_table\_association\_status) | The status of route table association bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_propagation_id"></a> [tr\_vpc\_route\_table\_propagation\_id](#output\_tr\_vpc\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_propagation_status"></a> [tr\_vpc\_route\_table\_propagation\_status](#output\_tr\_vpc\_route\_table\_propagation\_status) | The status of route table propagation bewteen TR and VPC. |
| <a name="output_vbr_id"></a> [vbr\_id](#output\_vbr\_id) | The ids of VBR. |
| <a name="output_vbr_route_table_id"></a> [vbr\_route\_table\_id](#output\_vbr\_route\_table\_id) | The route table id of VBR. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ids of vpc. |
| <a name="output_vpc_route_table_id"></a> [vpc\_route\_table\_id](#output\_vpc\_route\_table\_id) | The route table id of vpc. |
| <a name="output_vpc_status"></a> [vpc\_status](#output\_vpc\_status) | The status of vpc. |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | The ids of vswitches. |
| <a name="output_vswitch_status"></a> [vswitch\_status](#output\_vswitch\_status) | The status of vswitches. |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
