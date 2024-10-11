# CEN
output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = module.hz.cen_instance_id
}

# cn-hangzhou
output "cen_transit_router_id" {
  value       = module.hz.cen_transit_router_id
  description = "The id of CEN transit router in cn-hangzhou."
}

output "vbr_id" {
  value       = module.hz[*].vbr_id
  description = "The ids of VBR in cn-hangzhou."
}

output "tr_vbr_attachment_id" {
  value       = module.hz[*].tr_vbr_attachment_id
  description = "The id of attachment bewteen TR and VBR in cn-hangzhou."
}

output "health_check_id" {
  value       = module.hz[*].health_check_id
  description = "The id of health check in cn-hangzhou."
}

output "bgp_group_id" {
  value       = module.hz[*].bgp_group_id
  description = "The id of BGP group in cn-hangzhou."
}

output "bgp_peer_id" {
  value       = module.hz[*].bgp_peer_id
  description = "The id of BGP peer in cn-hangzhou."
}

output "vpc_id" {
  value       = module.hz[*].vpc_id
  description = "The ids of vpc in cn-hangzhou."
}

output "vswitch_ids" {
  value       = module.hz[*].vswitch_ids
  description = "The ids of vswitches in cn-hangzhou."
}

output "tr_vpc_attachment_id" {
  value       = module.hz[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and VPC in cn-hangzhou."
}
