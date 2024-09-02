provider "alicloud" {
  region = "cn-hangzhou"
}

data "alicloud_express_connect_physical_connections" "example" {
  name_regex = "^preserved-NODELETING"
}

module "hz" {
  source = "../.."
 
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

  vpc_config = var.vpc_config
}