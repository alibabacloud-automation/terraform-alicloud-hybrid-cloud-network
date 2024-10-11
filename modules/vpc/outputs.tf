# vpc
output "vpc_id" {
  value       = alicloud_vpc.this.id
  description = "The vpc id."
}

output "vpc_route_table_id" {
  value       = alicloud_vpc.this.route_table_id
  description = "The route table id of vpc."
}

output "vpc_status" {
  value       = alicloud_vpc.this.status
  description = "The status of vpc."
}

# vswitch
output "vswitch_ids" {
  value       = alicloud_vswitch.this[*].id
  description = "The ids of vswitches."
}

output "vswitch_status" {
  value       = alicloud_vswitch.this[*].status
  description = "The status of vswitches."
}

# tr_vpc_attachment
output "tr_vpc_attachment_id" {
  value       = alicloud_cen_transit_router_vpc_attachment.this.transit_router_attachment_id
  description = "The id of attachment between TR and VPC."
}

output "tr_vpc_attachment_status" {
  value       = alicloud_cen_transit_router_vpc_attachment.this.status
  description = "The status of attachment between TR and VPC."
}

output "tr_vpc_route_table_propagation_id" {
  value       = alicloud_cen_transit_router_route_table_propagation.this[*].id
  description = "The id of route table propagation bewteen TR and VPC."
}

output "tr_vpc_route_table_propagation_status" {
  value       = alicloud_cen_transit_router_route_table_propagation.this[*].status
  description = "The status of route table propagation bewteen TR and VPC."
}

output "tr_vpc_route_table_association_id" {
  value       = alicloud_cen_transit_router_route_table_association.this[*].id
  description = "The id of route table association bewteen TR and VPC."
}

output "tr_vpc_route_table_association_status" {
  value       = alicloud_cen_transit_router_route_table_association.this[*].status
  description = "The status of route table association bewteen TR and VPC."
}
