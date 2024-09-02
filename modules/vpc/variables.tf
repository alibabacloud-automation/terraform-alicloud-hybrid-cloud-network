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



# VPC

variable "vpc" {
  description = "The parameters of vpc. The attribute 'cidr_block' is required."
  type = object({
    cidr_block  = string
    vpc_name    = optional(string, null)
    enable_ipv6 = optional(bool, null)
    tags        = optional(map(string), {})
  })
  default = {
    cidr_block = null
  }
}

variable "vswitches" {
  description = "The parameters of vswitches. The attributes 'zone_id', 'cidr_block' are required."
  type = list(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
  }))
  default = []
}

variable "tr_vpc_attachment" {
  description = "The parameters of the attachment between TR and VPC."
  type = object({
    transit_router_attachment_name  = optional(string, null)
    auto_publish_route_enabled      = optional(bool, true)
    route_table_propagation_enabled = optional(bool, true)
    route_table_association_enabled = optional(bool, true)
  })
  default = {}
}
