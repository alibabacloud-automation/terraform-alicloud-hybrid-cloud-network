
# Complete

Configuration in this directory create Virtual Border Routers (VBRs) in `cn-hangzhou` and create Virtual Private Clouds (VPCs) in `cn-beijing` and `cn-shanghai`. Finalize the configuration of VPCs, Virtual Switches (VSWs), VBRs, TRs, etc., to ensure network integration is complete.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >=1.229.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud.hz"></a> [alicloud.hz](#provider\_alicloud.hz) | >=1.229.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bj"></a> [bj](#module\_bj) | ../.. | n/a |
| <a name="module_hz"></a> [hz](#module\_hz) | ../.. | n/a |
| <a name="module_sh"></a> [sh](#module\_sh) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_express_connect_physical_connections.example](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/express_connect_physical_connections) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bj_vpc_config"></a> [bj\_vpc\_config](#input\_bj\_vpc\_config) | The parameters of vpc resources in cn-beijing. | <pre>list(object({<br>    vpc               = map(string)<br>    vswitches         = list(map(string))<br>    tr_vpc_attachment = optional(map(string), {})<br>  }))</pre> | <pre>[<br>  {<br>    "tr_vpc_attachment": {<br>      "auto_publish_route_enabled": true,<br>      "route_table_association_enabled": true,<br>      "route_table_propagation_enabled": true,<br>      "transit_router_attachment_name": "bj_tr_attachment_name"<br>    },<br>    "vpc": {<br>      "cidr_block": "10.0.0.0/16"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "10.0.1.0/24",<br>        "vswitch_name": "bj_vswitch_1",<br>        "zone_id": "cn-beijing-i"<br>      },<br>      {<br>        "cidr_block": "10.0.2.0/24",<br>        "vswitch_name": "bj_vswitch_2",<br>        "zone_id": "cn-beijing-j"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    cen_instance_name = optional(string, null)<br>    protection_level  = optional(string, "REDUCED")<br>    description       = optional(string, null)<br>    tags              = optional(map(string), {})<br>  })</pre> | <pre>{<br>  "cen_instance_name": "cen_instance_name",<br>  "description": "cen_instance_description",<br>  "protection_level": "REDUCED",<br>  "tags": {<br>    "created_for": "module_example"<br>  }<br>}</pre> | no |
| <a name="input_sh_vpc_config"></a> [sh\_vpc\_config](#input\_sh\_vpc\_config) | The parameters of vpc resources in cn-shanghai. | <pre>list(object({<br>    vpc               = map(string)<br>    vswitches         = list(map(string))<br>    tr_vpc_attachment = optional(map(string), {})<br>  }))</pre> | <pre>[<br>  {<br>    "tr_vpc_attachment": {<br>      "auto_publish_route_enabled": true,<br>      "route_table_association_enabled": true,<br>      "route_table_propagation_enabled": true,<br>      "transit_router_attachment_name": "sh_tr_attachment_name"<br>    },<br>    "vpc": {<br>      "cidr_block": "10.0.0.0/16"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "10.0.1.0/24",<br>        "vswitch_name": "sh_vswitch_1",<br>        "zone_id": "cn-shanghai-e"<br>      },<br>      {<br>        "cidr_block": "10.0.2.0/24",<br>        "vswitch_name": "sh_vswitch_2",<br>        "zone_id": "cn-shanghai-f"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_tr_config"></a> [tr\_config](#input\_tr\_config) | The parameters of cen instance. | <pre>object({<br>    transit_router_name        = optional(string, null)<br>    transit_router_description = optional(string, null)<br>    support_multicast          = optional(string, null)<br>    tags                       = optional(map(string), {})<br>  })</pre> | <pre>{<br>  "support_multicast": "false",<br>  "tags": {<br>    "created_for": "module_example"<br>  },<br>  "transit_router_description": "hz_tr_description",<br>  "transit_router_name": "hz_tr_name"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_group_id"></a> [bgp\_group\_id](#output\_bgp\_group\_id) | The id of BGP group in cn-hangzhou. |
| <a name="output_bgp_peer_id"></a> [bgp\_peer\_id](#output\_bgp\_peer\_id) | The id of BGP peer in cn-hangzhou. |
| <a name="output_bj_cen_transit_router_id"></a> [bj\_cen\_transit\_router\_id](#output\_bj\_cen\_transit\_router\_id) | The id of CEN transit router in cn-beijing. |
| <a name="output_bj_tr_vpc_attachment_id"></a> [bj\_tr\_vpc\_attachment\_id](#output\_bj\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC in cn-beijing. |
| <a name="output_bj_vpc_id"></a> [bj\_vpc\_id](#output\_bj\_vpc\_id) | The ids of vpc in cn-beijing. |
| <a name="output_bj_vswitch_ids"></a> [bj\_vswitch\_ids](#output\_bj\_vswitch\_ids) | The ids of vswitches in cn-beijing. |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_express_connect_router_id"></a> [express\_connect\_router\_id](#output\_express\_connect\_router\_id) | The id of Express Connect Router. |
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | The id of health check in cn-hangzhou. |
| <a name="output_hz_cen_transit_router_id"></a> [hz\_cen\_transit\_router\_id](#output\_hz\_cen\_transit\_router\_id) | The id of CEN transit router. |
| <a name="output_sh_cen_transit_router_id"></a> [sh\_cen\_transit\_router\_id](#output\_sh\_cen\_transit\_router\_id) | The id of CEN transit router in cn-shanghai. |
| <a name="output_sh_tr_vpc_attachment_id"></a> [sh\_tr\_vpc\_attachment\_id](#output\_sh\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC in cn-shanghai. |
| <a name="output_sh_vpc_id"></a> [sh\_vpc\_id](#output\_sh\_vpc\_id) | The ids of vpc in cn-shanghai. |
| <a name="output_sh_vswitch_ids"></a> [sh\_vswitch\_ids](#output\_sh\_vswitch\_ids) | The ids of vswitches in cn-shanghai. |
| <a name="output_tr_ecr_attachment_id"></a> [tr\_ecr\_attachment\_id](#output\_tr\_ecr\_attachment\_id) | The attachment id between TR and ECR. |
| <a name="output_tr_vbr_attachment_id"></a> [tr\_vbr\_attachment\_id](#output\_tr\_vbr\_attachment\_id) | The id of attachment bewteen TR and VBR in cn-hangzhou. |
| <a name="output_vbr_id"></a> [vbr\_id](#output\_vbr\_id) | The ids of VBR in cn-hangzhou. |
<!-- END_TF_DOCS -->