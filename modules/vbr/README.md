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
| [alicloud_cen_transit_router_vbr_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vbr_attachment) | resource |
| [alicloud_cen_vbr_health_check.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_vbr_health_check) | resource |
| [alicloud_express_connect_virtual_border_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/express_connect_virtual_border_router) | resource |
| [alicloud_vpc_bgp_group.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc_bgp_group) | resource |
| [alicloud_vpc_bgp_peer.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc_bgp_peer) | resource |
| [alicloud_cen_transit_router_route_tables.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_id"></a> [cen\_instance\_id](#input\_cen\_instance\_id) | The id of cen instance. | `string` | `null` | no |
| <a name="input_cen_transit_router_id"></a> [cen\_transit\_router\_id](#input\_cen\_transit\_router\_id) | The id of cen transit router. | `string` | `null` | no |
| <a name="input_create_vbr_health_check"></a> [create\_vbr\_health\_check](#input\_create\_vbr\_health\_check) | whether to open vbr health check. Default to 'true' | `bool` | `true` | no |
| <a name="input_tr_vbr_attachment"></a> [tr\_vbr\_attachment](#input\_tr\_vbr\_attachment) | The parameters of the attachment between TR and VBR | <pre>object({<br>    transit_router_attachment_name        = optional(string, null)<br>    transit_router_attachment_description = optional(string, null)<br>    tags                                  = optional(map(string), {})<br>    auto_publish_route_enabled            = optional(bool, true)<br>    route_table_propagation_enabled       = optional(bool, true)<br>    route_table_association_enabled       = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_vbr"></a> [vbr](#input\_vbr) | The parameters of virtual border router. The attributes 'physical\_connection\_id', 'vlan\_id', 'local\_gateway\_ip', 'peer\_gateway\_ip', 'peering\_subnet\_mask' are required. | <pre>object({<br>    physical_connection_id     = string<br>    vlan_id                    = number<br>    local_gateway_ip           = string<br>    peer_gateway_ip            = string<br>    peering_subnet_mask        = string<br>    virtual_border_router_name = optional(string, null)<br>    description                = optional(string, null)<br>  })</pre> | <pre>{<br>  "local_gateway_ip": null,<br>  "peer_gateway_ip": null,<br>  "peering_subnet_mask": null,<br>  "physical_connection_id": null,<br>  "vlan_id": null<br>}</pre> | no |
| <a name="input_vbr_bgp_group"></a> [vbr\_bgp\_group](#input\_vbr\_bgp\_group) | The parameters of the bgp group. The attribute 'peer\_asn' is required. | <pre>object({<br>    peer_asn       = string<br>    auth_key       = optional(string, null)<br>    bgp_group_name = optional(string, null)<br>    description    = optional(string, null)<br>    is_fake_asn    = optional(bool, false)<br>  })</pre> | <pre>{<br>  "peer_asn": null<br>}</pre> | no |
| <a name="input_vbr_bgp_peer"></a> [vbr\_bgp\_peer](#input\_vbr\_bgp\_peer) | The parameters of the bgp peer. The default value of 'bfd\_multi\_hop' is 255. The default value of 'enable\_bfd' is 'false'. The default value of 'ip\_version' is 'IPV4'. | <pre>object({<br>    bfd_multi_hop   = optional(number, 255)<br>    enable_bfd      = optional(bool, "false")<br>    ip_version      = optional(string, "IPV4")<br>    peer_ip_address = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_vbr_health_check"></a> [vbr\_health\_check](#input\_vbr\_health\_check) | The parameters of vbr health check. The default value of 'health\_check\_interval' and 'healthy\_threshold' are 2 and 8 respectively. | <pre>object({<br>    health_check_interval = optional(number, 2)<br>    healthy_threshold     = optional(number, 8)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_group_id"></a> [bgp\_group\_id](#output\_bgp\_group\_id) | The id of BGP group. |
| <a name="output_bgp_group_status"></a> [bgp\_group\_status](#output\_bgp\_group\_status) | The status of BGP group. |
| <a name="output_bgp_peer_id"></a> [bgp\_peer\_id](#output\_bgp\_peer\_id) | The id of BGP peer. |
| <a name="output_bgp_peer_name"></a> [bgp\_peer\_name](#output\_bgp\_peer\_name) | The name of BGP peer. |
| <a name="output_bgp_peer_status"></a> [bgp\_peer\_status](#output\_bgp\_peer\_status) | The status of BGP peer. |
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | The id of health check. |
| <a name="output_tr_vbr_attachment_id"></a> [tr\_vbr\_attachment\_id](#output\_tr\_vbr\_attachment\_id) | The id of attachment bewteen TR and VBR. |
| <a name="output_tr_vbr_attachment_status"></a> [tr\_vbr\_attachment\_status](#output\_tr\_vbr\_attachment\_status) | The status of attachment bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_association_id"></a> [tr\_vbr\_route\_table\_association\_id](#output\_tr\_vbr\_route\_table\_association\_id) | The id of route table association bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_association_status"></a> [tr\_vbr\_route\_table\_association\_status](#output\_tr\_vbr\_route\_table\_association\_status) | The status of route table association bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_propagation_id"></a> [tr\_vbr\_route\_table\_propagation\_id](#output\_tr\_vbr\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_propagation_status"></a> [tr\_vbr\_route\_table\_propagation\_status](#output\_tr\_vbr\_route\_table\_propagation\_status) | The status of route table propagation bewteen TR and VBR. |
| <a name="output_vbr_id"></a> [vbr\_id](#output\_vbr\_id) | The id of VBR. |
| <a name="output_vbr_route_table_id"></a> [vbr\_route\_table\_id](#output\_vbr\_route\_table\_id) | The route table id of VBR. |
<!-- END_TF_DOCS -->