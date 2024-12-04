# CEN
output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = module.hz.cen_instance_id
}

# cn-hangzhou
output "hz_cen_transit_router_id" {
  description = "The id of CEN transit router."
  value       = module.hz.cen_transit_router_id
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

output "express_connect_router_id" {
  description = "The id of Express Connect Router."
  value       = module.hz[*].express_connect_router_id
}

output "tr_ecr_attachment_id" {
  description = "The attachment id between TR and ECR."
  value       = module.hz[*].tr_ecr_attachment_id
}

# cn-beijing
output "bj_cen_transit_router_id" {
  description = "The id of CEN transit router in cn-beijing."
  value       = module.bj.cen_transit_router_id
}

output "bj_vpc_id" {
  value       = module.bj[*].vpc_id
  description = "The ids of vpc in cn-beijing."
}

output "bj_vswitch_ids" {
  value       = module.bj[*].vswitch_ids
  description = "The ids of vswitches in cn-beijing."
}

output "bj_tr_vpc_attachment_id" {
  value       = module.bj[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and VPC in cn-beijing."
}

# cn-shanghai
output "sh_cen_transit_router_id" {
  description = "The id of CEN transit router in cn-shanghai."
  value       = module.sh.cen_transit_router_id
}

output "sh_vpc_id" {
  value       = module.sh[*].vpc_id
  description = "The ids of vpc in cn-shanghai."
}

output "sh_vswitch_ids" {
  value       = module.sh[*].vswitch_ids
  description = "The ids of vswitches in cn-shanghai."
}

output "sh_tr_vpc_attachment_id" {
  value       = module.sh[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and VPC in cn-shanghai."
}
