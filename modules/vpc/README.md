Terraform submodule to build hybrid cloud/multi-cloud network for Alibaba Cloud

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

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_transit_router_route_table_association.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vpc_attachment) | resource |
| [alicloud_route_entry.this_1](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_entry) | resource |
| [alicloud_route_entry.this_2](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_entry) | resource |
| [alicloud_route_entry.this_3](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_entry) | resource |
| [alicloud_vpc.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_cen_transit_router_route_tables.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_id"></a> [cen\_instance\_id](#input\_cen\_instance\_id) | The id of cen instance. | `string` | `null` | no |
| <a name="input_cen_transit_router_id"></a> [cen\_transit\_router\_id](#input\_cen\_transit\_router\_id) | The id of cen transit router. | `string` | `null` | no |
| <a name="input_tr_vpc_attachment"></a> [tr\_vpc\_attachment](#input\_tr\_vpc\_attachment) | The parameters of the attachment between TR and VPC. | <pre>object({<br>    transit_router_attachment_name  = optional(string, null)<br>    auto_publish_route_enabled      = optional(bool, true)<br>    route_table_propagation_enabled = optional(bool, true)<br>    route_table_association_enabled = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The parameters of vpc. The attribute 'cidr\_block' is required. | <pre>object({<br>    cidr_block  = string<br>    vpc_name    = optional(string, null)<br>    enable_ipv6 = optional(bool, null)<br>    tags        = optional(map(string), {})<br>  })</pre> | <pre>{<br>  "cidr_block": null<br>}</pre> | no |
| <a name="input_vswitches"></a> [vswitches](#input\_vswitches) | The parameters of vswitches. The attributes 'zone\_id', 'cidr\_block' are required. | <pre>list(object({<br>    zone_id      = string<br>    cidr_block   = string<br>    vswitch_name = optional(string, null)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tr_vpc_attachment_id"></a> [tr\_vpc\_attachment\_id](#output\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC. |
| <a name="output_tr_vpc_attachment_status"></a> [tr\_vpc\_attachment\_status](#output\_tr\_vpc\_attachment\_status) | The status of attachment between TR and VPC. |
| <a name="output_tr_vpc_route_table_association_id"></a> [tr\_vpc\_route\_table\_association\_id](#output\_tr\_vpc\_route\_table\_association\_id) | The id of route table association bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_association_status"></a> [tr\_vpc\_route\_table\_association\_status](#output\_tr\_vpc\_route\_table\_association\_status) | The status of route table association bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_propagation_id"></a> [tr\_vpc\_route\_table\_propagation\_id](#output\_tr\_vpc\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_propagation_status"></a> [tr\_vpc\_route\_table\_propagation\_status](#output\_tr\_vpc\_route\_table\_propagation\_status) | The status of route table propagation bewteen TR and VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The vpc id. |
| <a name="output_vpc_route_table_id"></a> [vpc\_route\_table\_id](#output\_vpc\_route\_table\_id) | The route table id of vpc. |
| <a name="output_vpc_status"></a> [vpc\_status](#output\_vpc\_status) | The status of vpc. |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | The ids of vswitches. |
| <a name="output_vswitch_status"></a> [vswitch\_status](#output\_vswitch\_status) | The status of vswitches. |
<!-- END_TF_DOCS -->