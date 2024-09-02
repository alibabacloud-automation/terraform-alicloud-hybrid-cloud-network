# Basic

Configuration in this directory create Virtual Border Routers (VBRs) and Virtual Private Clouds (VPCs) in `cn-hangzhou`. Finalize the configuration of VPCs, Virtual Switches (VSWs), VBRs, TRs, etc., to ensure network integration is complete.

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
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >=1.229.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hz"></a> [hz](#module\_hz) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_express_connect_physical_connections.example](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/express_connect_physical_connections) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc               = map(string)<br>    vswitches         = list(map(string))<br>    tr_vpc_attachment = optional(map(string), {})<br>  }))</pre> | <pre>[<br>  {<br>    "vpc": {<br>      "cidr_block": "10.0.0.0/16"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "10.0.1.0/24",<br>        "zone_id": "cn-hangzhou-i"<br>      },<br>      {<br>        "cidr_block": "10.0.2.0/24",<br>        "zone_id": "cn-hangzhou-j"<br>      }<br>    ]<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_group_id"></a> [bgp\_group\_id](#output\_bgp\_group\_id) | The id of BGP group in cn-hangzhou. |
| <a name="output_bgp_peer_id"></a> [bgp\_peer\_id](#output\_bgp\_peer\_id) | The id of BGP peer in cn-hangzhou. |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_cen_transit_router_id"></a> [cen\_transit\_router\_id](#output\_cen\_transit\_router\_id) | The id of CEN transit router in cn-hangzhou. |
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | The id of health check in cn-hangzhou. |
| <a name="output_tr_vbr_attachment_id"></a> [tr\_vbr\_attachment\_id](#output\_tr\_vbr\_attachment\_id) | The id of attachment bewteen TR and VBR in cn-hangzhou. |
| <a name="output_tr_vpc_attachment_id"></a> [tr\_vpc\_attachment\_id](#output\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC in cn-hangzhou. |
| <a name="output_vbr_id"></a> [vbr\_id](#output\_vbr\_id) | The ids of VBR in cn-hangzhou. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ids of vpc in cn-hangzhou. |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | The ids of vswitches in cn-hangzhou. |
<!-- END_TF_DOCS -->