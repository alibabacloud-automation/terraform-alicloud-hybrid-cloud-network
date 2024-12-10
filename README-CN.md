Terraform module to build hybrid cloud/multi-cloud network for Alibaba Cloud

terraform-alicloud-hybrid-cloud-network
======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/blob/main/README.md) | 简体中文

本卓越架构设计重点介绍当存在云上云下业务协同或者多云协同场景时，如何实现通过物理专线和阿里云云网络产品实现云上云下或多云间的业务协同，快速构建安全、稳定、弹性的混合云/多云协同网络，以满足客户的云化进程。操作流程简介如下：
1. 通过物理专线实现IDC/三方云厂商与阿里云专线接入点的连接；
2. 基于专线实例按需创建边界路由器VBR，不同的VBR间逻辑隔离；
3. 高速通道VBR与云上VPC通过转发路由器TR实现互联互通，您可以将云上多地域的VPC与分布在多地的IDC或三方云资源实现安全、稳定的互联互通。
4. 完成VPC、VSW、VBR、TR等实例的配置，完成网络打通。

架构图:


V2.0:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/main/scripts/diagramv2.png)

V1.0：

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/main/scripts/diagram.png)

## 用法

在杭州区域创建VBR、ECR资源

```hcl
# cn-hangzhou
provider "alicloud" {
  region = "cn-hangzhou"
  alias  = "hz"
}
data "alicloud_express_connect_physical_connections" "example" {
  provider   = alicloud.hz
  name_regex = "^preserved-NODELETING"
}
module "hz" {
  source  = "alibabacloud-automation/hybrid-cloud-network/alicloud"
  version = "~> 2.0"

  providers = {
    alicloud = alicloud.hz
  }

  create_cen_instance       = true
  cen_instance_config       = var.cen_instance_config
  create_cen_transit_router = true
  tr_config                 = var.tr_config

  create_vbr_resources = true
  vbr_config = [
    {
      vbr = {
        physical_connection_id     = data.alicloud_express_connect_physical_connections.example.connections[0].id
        vlan_id                    = 204
        local_gateway_ip           = "192.168.0.1"
        peer_gateway_ip            = "192.168.0.2"
        peering_subnet_mask        = "255.255.255.252"
        virtual_border_router_name = "vbr_1_name"
        description                = "vbr_1_description"
      },

      vbr_health_check = {
        create_vbr_health_check = true
        health_check_interval   = 2
        healthy_threshold       = 8
      },
      vbr_bgp_group = {
        bgp_group_name = "bgp_1"
        description    = "VPC-idc"
        peer_asn       = 45000
        is_fake_asn    = false
      },
      vbr_bgp_peer = {
        bfd_multi_hop   = "10"
        enable_bfd      = true
        ip_version      = "IPV4"
        peer_ip_address = "1.1.1.1"
      }
    },
    {
      vbr = {
        physical_connection_id     = data.alicloud_express_connect_physical_connections.example.connections[1].id
        vlan_id                    = 205
        local_gateway_ip           = "192.168.1.1"
        peer_gateway_ip            = "192.168.1.2"
        peering_subnet_mask        = "255.255.255.252"
        virtual_border_router_name = "vbr_2_name"
        description                = "vbr_2_description"
      },
      vbr_health_check = {
        create_vbr_health_check = false
      },
      vbr_bgp_group = {
        bgp_group_name = "tf_bgp_2"
        description    = "VPC-idc"
        peer_asn       = 45000
      },
      vbr_bgp_peer = {
        bfd_multi_hop   = "10"
        enable_bfd      = true
        ip_version      = "IPV4"
        peer_ip_address = "1.1.1.1"
      }
    }
  ]

  enable_ecr = true
  ecr_config = {
    alibaba_side_asn                   = 65214
    ecr_name                           = "ecr_name"
    transit_router_ecr_attachment_name = "ecr_tr_attachment_name"
  }

  create_vpc_resources = false
}

# cn-beijing
provider "alicloud" {
  region = "cn-beijing"
  alias  = "bj"
}

module "bj" {
  source  = "alibabacloud-automation/hybrid-cloud-network/alicloud"
  version = "~> 2.0"

  providers = {
    alicloud = alicloud.bj
  }

  create_cen_instance       = false
  cen_instance_id           = module.hz.cen_instance_id
  create_cen_transit_router = true

  create_vbr_resources = false

  create_vpc_resources = true
  vpc_config           = var.bj_vpc_config

}

# cn-shanghai
provider "alicloud" {
  region = "cn-shanghai"
  alias  = "sh"
}

module "sh" {
  source  = "alibabacloud-automation/hybrid-cloud-network/alicloud"
  version = "~> 2.0"

  providers = {
    alicloud = alicloud.sh
  }

  create_cen_instance       = false
  cen_instance_id           = module.hz.cen_instance_id
  create_cen_transit_router = true

  create_vbr_resources = false

  create_vpc_resources = true
  vpc_config           = var.sh_vpc_config
}
```


在同一个地域创建 VPC、VBR 资源

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

在杭州地域创建 VBR 资源，在北京区域创建 VPC、 VSwitch 资源

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

## 示例

* [基础用法](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/tree/main/examples/basic)
* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/tree/main/examples/complete)
* [创建ECR完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/tree/main/examples/complete-with-ecr)


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
| [alicloud_cen_transit_router_ecr_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_ecr_attachment) | resource |
| [alicloud_cen_transit_router_route_table_association.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_express_connect_router_express_connect_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/express_connect_router_express_connect_router) | resource |
| [alicloud_express_connect_router_tr_association.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/express_connect_router_tr_association) | resource |
| [alicloud_account.current](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_cen_transit_router_route_tables.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

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
| <a name="input_ecr_config"></a> [ecr\_config](#input\_ecr\_config) | The parameters of ecr. | <pre>object({<br>    alibaba_side_asn                          = number<br>    ecr_name                                  = optional(string, null)<br>    description                               = optional(string, null)<br>    transit_router_ecr_attachment_name        = optional(string, null)<br>    transit_router_ecr_attachment_description = optional(string, null)<br>    route_table_propagation_enabled           = optional(bool, true)<br>    route_table_association_enabled           = optional(bool, true)<br>  })</pre> | <pre>{<br>  "alibaba_side_asn": null<br>}</pre> | no |
| <a name="input_enable_ecr"></a> [enable\_ecr](#input\_enable\_ecr) | Whether to enable ECR between TR and VBRs. Default to 'false'. | `bool` | `false` | no |
| <a name="input_exsiting_ecr_id"></a> [exsiting\_ecr\_id](#input\_exsiting\_ecr\_id) | Specify an existing ecr id. If not set, a new ecr will be created. If set, the attribute 'alibaba\_side\_asn' of ecr\_config must be set, too. | `string` | `null` | no |
| <a name="input_tr_config"></a> [tr\_config](#input\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, null)<br>    transit_router_description = optional(string, null)<br>    support_multicast          = optional(string, null)<br>    tags                       = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_vbr_config"></a> [vbr\_config](#input\_vbr\_config) | The list parameters of vbr resources. The attributes 'vbr', 'vbr\_bgp\_group' are required. | <pre>list(object({<br>    vbr = object({<br>      physical_connection_id     = string<br>      vlan_id                    = number<br>      local_gateway_ip           = string<br>      peer_gateway_ip            = string<br>      peering_subnet_mask        = string<br>      virtual_border_router_name = optional(string, null)<br>      description                = optional(string, null)<br>    })<br>    tr_vbr_attachment = optional(object({<br>      transit_router_attachment_name        = optional(string, null)<br>      transit_router_attachment_description = optional(string, null)<br>      tags                                  = optional(map(string), {})<br>      auto_publish_route_enabled            = optional(bool, true)<br>      route_table_propagation_enabled       = optional(bool, true)<br>      route_table_association_enabled       = optional(bool, true)<br>    }), {})<br>    vbr_health_check = optional(object({<br>      create_vbr_health_check = optional(bool, true)<br>      health_check_interval   = optional(number, 2)<br>      healthy_threshold       = optional(number, 8)<br>    }), {})<br>    vbr_bgp_group = object({<br>      peer_asn       = string<br>      auth_key       = optional(string, null)<br>      bgp_group_name = optional(string, null)<br>      description    = optional(string, null)<br>      is_fake_asn    = optional(bool, false)<br>      local_asn      = optional(number, null)<br>    })<br>    vbr_bgp_peer = optional(object({<br>      bfd_multi_hop   = optional(number, 255)<br>      enable_bfd      = optional(bool, "false")<br>      ip_version      = optional(string, "IPV4")<br>      peer_ip_address = optional(string, null)<br>    }), {})<br>  }))</pre> | <pre>[<br>  {<br>    "vbr": {<br>      "local_gateway_ip": null,<br>      "peer_gateway_ip": null,<br>      "peering_subnet_mask": null,<br>      "physical_connection_id": null,<br>      "vlan_id": null<br>    },<br>    "vbr_bgp_group": {<br>      "peer_asn": null<br>    }<br>  }<br>]</pre> | no |
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
| <a name="output_express_connect_router_id"></a> [express\_connect\_router\_id](#output\_express\_connect\_router\_id) | The id of Express Connect Router. |
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | The id of health check. |
| <a name="output_tr_ecr_attachment_id"></a> [tr\_ecr\_attachment\_id](#output\_tr\_ecr\_attachment\_id) | The attachment id between TR and ECR. |
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

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
