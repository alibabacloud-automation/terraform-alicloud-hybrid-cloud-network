
/*
 * vbr
 */
resource "alicloud_express_connect_virtual_border_router" "this" {
  physical_connection_id     = var.vbr.physical_connection_id
  vlan_id                    = var.vbr.vlan_id
  local_gateway_ip           = var.vbr.local_gateway_ip
  peer_gateway_ip            = var.vbr.peer_gateway_ip
  peering_subnet_mask        = var.vbr.peering_subnet_mask
  virtual_border_router_name = var.vbr.virtual_border_router_name
  description                = var.vbr.description
}

resource "alicloud_cen_transit_router_vbr_attachment" "this" {
  vbr_id                                = alicloud_express_connect_virtual_border_router.this.id
  cen_id                                = var.cen_instance_id
  transit_router_id                     = var.cen_transit_router_id
  transit_router_attachment_name        = var.tr_vbr_attachment.transit_router_attachment_name
  transit_router_attachment_description = var.tr_vbr_attachment.transit_router_attachment_description
  tags                                  = var.tr_vbr_attachment.tags
  auto_publish_route_enabled            = var.tr_vbr_attachment.auto_publish_route_enabled
}

/*
 * TR Route Table
 */
data "alicloud_cen_transit_router_route_tables" "this" {
  transit_router_id               = var.cen_transit_router_id
  transit_router_route_table_type = "System"
}

resource "alicloud_cen_transit_router_route_table_propagation" "this" {
  count = var.tr_vbr_attachment.route_table_propagation_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vbr_attachment.this.transit_router_attachment_id
}


resource "alicloud_cen_transit_router_route_table_association" "this" {
  count = var.tr_vbr_attachment.route_table_association_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vbr_attachment.this.transit_router_attachment_id
}

/*
 * vbr_health_check
 */
data "alicloud_regions" "this" {
  current = true
}

resource "alicloud_cen_vbr_health_check" "this" {
  count = var.create_vbr_health_check ? 1 : 0

  cen_id                 = var.cen_instance_id
  vbr_instance_id        = alicloud_express_connect_virtual_border_router.this.id
  health_check_target_ip = alicloud_express_connect_virtual_border_router.this.peer_gateway_ip
  vbr_instance_region_id = data.alicloud_regions.this.regions[0].id
  health_check_interval  = var.vbr_health_check.health_check_interval
  healthy_threshold      = var.vbr_health_check.healthy_threshold
}


/*
 * bgp_group & bgp_peer
 */
resource "alicloud_vpc_bgp_group" "this" {
  router_id      = alicloud_express_connect_virtual_border_router.this.id
  auth_key       = var.vbr_bgp_group.auth_key
  bgp_group_name = var.vbr_bgp_group.bgp_group_name
  peer_asn       = var.vbr_bgp_group.peer_asn
  is_fake_asn    = var.vbr_bgp_group.is_fake_asn
  description    = var.vbr_bgp_group.description
}

resource "alicloud_vpc_bgp_peer" "this" {
  bgp_group_id    = alicloud_vpc_bgp_group.this.id
  bfd_multi_hop   = var.vbr_bgp_peer.bfd_multi_hop
  enable_bfd      = var.vbr_bgp_peer.enable_bfd
  ip_version      = var.vbr_bgp_peer.ip_version
  peer_ip_address = var.vbr_bgp_peer.peer_ip_address
}
