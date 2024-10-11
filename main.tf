locals {
  cen_instance_id       = var.create_cen_instance ? alicloud_cen_instance.this[0].id : var.cen_instance_id
  cen_transit_router_id = var.create_cen_transit_router ? alicloud_cen_transit_router.this[0].transit_router_id : var.cen_transit_router_id
}

/*
 * CEN
 */
resource "alicloud_cen_instance" "this" {
  count = var.create_cen_instance ? 1 : 0

  cen_instance_name = var.cen_instance_config.cen_instance_name
  protection_level  = var.cen_instance_config.protection_level
  description       = var.cen_instance_config.description
  tags              = var.cen_instance_config.tags
}


/*
 * TR
 */
resource "alicloud_cen_transit_router" "this" {
  count = var.create_cen_transit_router ? 1 : 0

  cen_id                     = local.cen_instance_id
  transit_router_name        = var.tr_config.transit_router_name
  transit_router_description = var.tr_config.transit_router_description
  support_multicast          = var.tr_config.support_multicast
  tags                       = var.tr_config.tags
}

/*
 * VBR
 */
module "vbr" {
  source = "./modules/vbr"

  count = var.create_vbr_resources ? length(var.vbr_config) : 0

  cen_instance_id       = local.cen_instance_id
  cen_transit_router_id = local.cen_transit_router_id

  vbr                     = var.vbr_config[count.index].vbr
  tr_vbr_attachment       = var.vbr_config[count.index].tr_vbr_attachment
  create_vbr_health_check = var.vbr_config[count.index].vbr_health_check.create_vbr_health_check
  vbr_health_check        = var.vbr_config[count.index].vbr_health_check
  vbr_bgp_group           = var.vbr_config[count.index].vbr_bgp_group
  vbr_bgp_peer            = var.vbr_config[count.index].vbr_bgp_peer

}


/*
 * VPC
 */
module "vpc" {
  source = "./modules/vpc"
  count  = var.create_vpc_resources ? length(var.vpc_config) : 0

  cen_instance_id       = local.cen_instance_id
  cen_transit_router_id = local.cen_transit_router_id

  vpc               = var.vpc_config[count.index].vpc
  vswitches         = var.vpc_config[count.index].vswitches
  tr_vpc_attachment = var.vpc_config[count.index].tr_vpc_attachment
}
