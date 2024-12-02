# VBR
output "vbr_id" {
  value       = alicloud_express_connect_virtual_border_router.this.id
  description = "The id of VBR."
}

output "vbr_route_table_id" {
  value       = alicloud_express_connect_virtual_border_router.this.route_table_id
  description = "The route table id of VBR."
}

# tr_vbr_attachment
output "tr_vbr_attachment_id" {
  value       = one(alicloud_cen_transit_router_vbr_attachment.this[*].transit_router_attachment_id)
  description = "The id of attachment bewteen TR and VBR."
}

output "tr_vbr_attachment_status" {
  value       = one(alicloud_cen_transit_router_vbr_attachment.this[*].status)
  description = "The status of attachment bewteen TR and VBR."
}

output "tr_vbr_route_table_propagation_id" {
  value       = alicloud_cen_transit_router_route_table_propagation.this[*].id
  description = "The id of route table propagation bewteen TR and VBR."
}

output "tr_vbr_route_table_propagation_status" {
  value       = alicloud_cen_transit_router_route_table_propagation.this[*].status
  description = "The status of route table propagation bewteen TR and VBR."
}

output "tr_vbr_route_table_association_id" {
  value       = alicloud_cen_transit_router_route_table_association.this[*].id
  description = "The id of route table association bewteen TR and VBR."
}

output "tr_vbr_route_table_association_status" {
  value       = alicloud_cen_transit_router_route_table_association.this[*].status
  description = "The status of route table association bewteen TR and VBR."
}

# vbr_health_check
output "health_check_id" {
  value       = alicloud_cen_vbr_health_check.this[*].id
  description = "The id of health check."
}

# bgp_group
output "bgp_group_id" {
  value       = alicloud_vpc_bgp_group.this.id
  description = "The id of BGP group."
}

output "bgp_group_status" {
  value       = alicloud_vpc_bgp_group.this.status
  description = "The status of BGP group."
}

# bgp_peer
output "bgp_peer_id" {
  value       = alicloud_vpc_bgp_peer.this.id
  description = "The id of BGP peer."
}

output "bgp_peer_name" {
  value       = alicloud_vpc_bgp_peer.this.bgp_peer_name
  description = "The name of BGP peer."
}

output "bgp_peer_status" {
  value       = alicloud_vpc_bgp_peer.this.status
  description = "The status of BGP peer."
}