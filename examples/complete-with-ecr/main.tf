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
  source = "../.."
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
  source = "../.."
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
  source = "../.."
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
