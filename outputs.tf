# CEN
output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = local.cen_instance_id
}

output "cen_instance_status" {
  description = "The status of CEN instance."
  value       = alicloud_cen_instance.this[*].status
}

# TR
output "cen_transit_router_id" {
  description = "The id of CEN transit router."
  value       = local.cen_transit_router_id
}

output "cen_transit_router_type" {
  description = "The type of CEN transit router."
  value       = alicloud_cen_transit_router.this[*].type
}

output "cen_transit_router_support_multicast" {
  description = "The status of CEN transit router."
  value       = alicloud_cen_transit_router.this[*].status
}


# VBR
output "vbr_id" {
  value       = module.vbr[*].vbr_id
  description = "The ids of VBR."
}

output "vbr_route_table_id" {
  value       = module.vbr[*].vbr_route_table_id
  description = "The route table id of VBR."
}

# vbr_attachment
output "tr_vbr_attachment_id" {
  value       = module.vbr[*].tr_vbr_attachment_id
  description = "The id of attachment bewteen TR and VBR."
}


output "tr_vbr_attachment_status" {
  value       = module.vbr[*].tr_vbr_attachment_status
  description = "The status of attachment bewteen TR and VBR."
}

output "tr_vbr_route_table_propagation_id" {
  value       = module.vbr[*].tr_vbr_route_table_propagation_id
  description = "The id of route table propagation bewteen TR and VBR."
}

output "tr_vbr_route_table_propagation_status" {
  value       = module.vbr[*].tr_vbr_route_table_propagation_status
  description = "The status of route table propagation bewteen TR and VBR."
}

output "tr_vbr_route_table_association_id" {
  value       = module.vbr[*].tr_vbr_route_table_association_id
  description = "The id of route table association bewteen TR and VBR."
}

output "tr_vbr_route_table_association_status" {
  value       = module.vbr[*].tr_vbr_route_table_association_status
  description = "The status of route table association bewteen TR and VBR."
}


# vbr_health_check
output "health_check_id" {
  value       = module.vbr[*].health_check_id
  description = "The id of health check."
}

# bgp_group
output "bgp_group_id" {
  value       = module.vbr[*].bgp_group_id
  description = "The id of BGP group."
}

output "bgp_group_status" {
  value       = module.vbr[*].bgp_group_status
  description = "The status of BGP group."
}

# bgp_peer
output "bgp_peer_id" {
  value       = module.vbr[*].bgp_peer_id
  description = "The id of BGP peer."
}

output "bgp_peer_name" {
  value       = module.vbr[*].bgp_peer_name
  description = "The name of BGP peer."
}

output "bgp_peer_status" {
  value       = module.vbr[*].bgp_peer_status
  description = "The status of BGP peer."
}


# vpc
output "vpc_id" {
  value       = module.vpc[*].vpc_id
  description = "The ids of vpc."
}

output "vpc_route_table_id" {
  value       = module.vpc[*].vpc_route_table_id
  description = "The route table id of vpc."
}

output "vpc_status" {
  value       = module.vpc[*].vpc_status
  description = "The status of vpc."
}

# vswitch
output "vswitch_ids" {
  value       = module.vpc[*].vswitch_ids
  description = "The ids of vswitches."
}


output "vswitch_status" {
  value       = module.vpc[*].vswitch_status
  description = "The status of vswitches."
}

# tr_vpc_attachment
output "tr_vpc_attachment_id" {
  value       = module.vpc[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and VPC."
}

output "tr_vpc_attachment_status" {
  value       = module.vpc[*].tr_vpc_attachment_status
  description = "The status of attachment between TR and VPC."
}

output "tr_vpc_route_table_propagation_id" {
  value       = module.vpc[*].tr_vpc_route_table_propagation_id
  description = "The id of route table propagation bewteen TR and VPC."
}

output "tr_vpc_route_table_propagation_status" {
  value       = module.vpc[*].tr_vpc_route_table_propagation_status
  description = "The status of route table propagation bewteen TR and VPC."
}

output "tr_vpc_route_table_association_id" {
  value       = module.vpc[*].tr_vpc_route_table_association_id
  description = "The id of route table association bewteen TR and VPC."
}

output "tr_vpc_route_table_association_status" {
  value       = module.vpc[*].tr_vpc_route_table_association_status
  description = "The status of route table association bewteen TR and VPC."
}
