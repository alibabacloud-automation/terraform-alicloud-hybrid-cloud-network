
# CEN
variable "create_cen_instance" {
  description = "Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen_instance_id'. Default to 'true'"
  type        = bool
  default     = true
}


variable "cen_instance_id" {
  description = "The id of an exsiting cen instance."
  type        = string
  default     = null
}

variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    cen_instance_name = optional(string, null)
    protection_level  = optional(string, "REDUCED")
    description       = optional(string, null)
    tags              = optional(map(string), {})
  })
  default = {}
}


# TR
variable "create_cen_transit_router" {
  description = "Whether to create transit router. If false, you can specify an existing transit router by setting 'cen_transit_router_id'. Default to 'true'"
  type        = bool
  default     = true
}

variable "cen_transit_router_id" {
  description = "The transit router id of an existing transit router."
  type        = string
  default     = null
}

variable "tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, null)
    transit_router_description = optional(string, null)
    support_multicast          = optional(string, null)
    tags                       = optional(map(string), {})
  })
  default = {}
}

variable "enable_ecr" {
  description = "Whether to enable ECR between TR and VBRs. Default to 'false'."
  type        = bool
  default     = false
}

variable "exsiting_ecr_id" {
  description = "Specify an existing ecr id. If not set, a new ecr will be created. If set, the attribute 'alibaba_side_asn' of ecr_config must be set, too."
  type        = string
  default     = null
}

variable "ecr_config" {
  description = "The parameters of ecr."
  type = object({
    alibaba_side_asn                          = number
    ecr_name                                  = optional(string, null)
    description                               = optional(string, null)
    transit_router_ecr_attachment_name        = optional(string, null)
    transit_router_ecr_attachment_description = optional(string, null)
    route_table_propagation_enabled           = optional(bool, true)
    route_table_association_enabled           = optional(bool, true)
  })
  default = {
    alibaba_side_asn = null
  }

}

# VBR
variable "create_vbr_resources" {
  description = "Whether to create vbr resources. Default to 'true'"
  type        = bool
  default     = true
}

variable "vbr_config" {
  description = "The list parameters of vbr resources. The attributes 'vbr', 'vbr_bgp_group' are required."
  type = list(object({
    vbr = object({
      physical_connection_id     = string
      vlan_id                    = number
      local_gateway_ip           = string
      peer_gateway_ip            = string
      peering_subnet_mask        = string
      virtual_border_router_name = optional(string, null)
      description                = optional(string, null)
    })
    tr_vbr_attachment = optional(object({
      transit_router_attachment_name        = optional(string, null)
      transit_router_attachment_description = optional(string, null)
      tags                                  = optional(map(string), {})
      auto_publish_route_enabled            = optional(bool, true)
      route_table_propagation_enabled       = optional(bool, true)
      route_table_association_enabled       = optional(bool, true)
    }), {})
    vbr_health_check = optional(object({
      create_vbr_health_check = optional(bool, true)
      health_check_interval   = optional(number, 2)
      healthy_threshold       = optional(number, 8)
    }), {})
    vbr_bgp_group = object({
      peer_asn       = string
      auth_key       = optional(string, null)
      bgp_group_name = optional(string, null)
      description    = optional(string, null)
      is_fake_asn    = optional(bool, false)
    })
    vbr_bgp_peer = optional(object({
      bfd_multi_hop   = optional(number, 255)
      enable_bfd      = optional(bool, "false")
      ip_version      = optional(string, "IPV4")
      peer_ip_address = optional(string, null)
    }), {})
  }))
  default = [
    {
      vbr = {
        physical_connection_id = null
        vlan_id                = null
        local_gateway_ip       = null
        peer_gateway_ip        = null
        peering_subnet_mask    = null
      },
      vbr_bgp_group = {
        peer_asn = null
      }
    }
  ]
}

# vpc、vswitch 参数
variable "create_vpc_resources" {
  description = "Whether to create vpc resources. Default to 'true'"
  type        = bool
  default     = true
}

variable "vpc_config" {
  description = "The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = map(string)
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = []
}


