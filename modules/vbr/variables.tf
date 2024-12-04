# CEN
variable "cen_instance_id" {
  description = "The id of cen instance."
  type        = string
  default     = null
}


# TR
variable "cen_transit_router_id" {
  description = "The id of cen transit router."
  type        = string
  default     = null
}


# ecr
variable "enable_ecr" {
  description = "Whether to enable ecr. Default to 'false'"
  type        = bool
  default     = false
}

variable "ecr_id" {
  description = "The id of express connect router."
  type        = string
  default     = null
}



# vbr
variable "vbr" {
  description = "The parameters of virtual border router. The attributes 'physical_connection_id', 'vlan_id', 'local_gateway_ip', 'peer_gateway_ip', 'peering_subnet_mask' are required."
  type = object({
    physical_connection_id     = string
    vlan_id                    = number
    local_gateway_ip           = string
    peer_gateway_ip            = string
    peering_subnet_mask        = string
    virtual_border_router_name = optional(string, null)
    description                = optional(string, null)
  })
  default = {
    physical_connection_id = null
    vlan_id                = null
    local_gateway_ip       = null
    peer_gateway_ip        = null
    peering_subnet_mask    = null
  }
}

variable "tr_vbr_attachment" {
  description = "The parameters of the attachment between TR and VBR "
  type = object({
    transit_router_attachment_name        = optional(string, null)
    transit_router_attachment_description = optional(string, null)
    tags                                  = optional(map(string), {})
    auto_publish_route_enabled            = optional(bool, true)
    route_table_propagation_enabled       = optional(bool, true)
    route_table_association_enabled       = optional(bool, true)
  })
  default = {}
}

# health_check
variable "create_vbr_health_check" {
  description = "whether to open vbr health check. Default to 'true'"
  type        = bool
  default     = true
}

variable "vbr_health_check" {
  description = "The parameters of vbr health check. The default value of 'health_check_interval' and 'healthy_threshold' are 2 and 8 respectively."
  type = object({
    health_check_interval = optional(number, 2)
    healthy_threshold     = optional(number, 8)
  })
  default = {}
}


# BGP
variable "vbr_bgp_group" {
  description = "The parameters of the bgp group. The attribute 'peer_asn' is required."
  type = object({
    peer_asn       = string
    auth_key       = optional(string, null)
    bgp_group_name = optional(string, null)
    description    = optional(string, null)
    is_fake_asn    = optional(bool, false)
  })
  default = {
    peer_asn = null
  }
}

variable "vbr_bgp_peer" {
  description = "The parameters of the bgp peer. The default value of 'bfd_multi_hop' is 255. The default value of 'enable_bfd' is 'false'. The default value of 'ip_version' is 'IPV4'."
  type = object({
    bfd_multi_hop   = optional(number, 255)
    enable_bfd      = optional(bool, "false")
    ip_version      = optional(string, "IPV4")
    peer_ip_address = optional(string, null)
  })
  default = {}
}
