
# CEN
variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    cen_instance_name = optional(string, null)
    protection_level  = optional(string, "REDUCED")
    description       = optional(string, null)
    tags              = optional(map(string), {})
  })
  default = {
    cen_instance_name = "cen_instance_name"
    protection_level  = "REDUCED"
    description       = "cen_instance_description"
    tags = {
      "created_for" : "module_example"
    },
  }
}


# TR
variable "tr_config" {
  description = "The parameters of cen instance."
  type = object({
    transit_router_name        = optional(string, null)
    transit_router_description = optional(string, null)
    support_multicast          = optional(string, null)
    tags                       = optional(map(string), {})
  })
  default = {
    transit_router_name        = "hz_tr_name"
    transit_router_description = "hz_tr_description"
    support_multicast          = "false"
    tags = {
      "created_for" : "module_example"
    },
  }
}

variable "bj_vpc_config" {
  description = "The parameters of vpc resources in cn-beijing."
  type = list(object({
    vpc               = map(string)
    vswitches         = list(map(string))
    tr_vpc_attachment = optional(map(string), {})
  }))
  default = [{
    vpc = {
      cidr_block = "10.0.0.0/16"
    },
    vswitches = [
      {
        zone_id      = "cn-beijing-i"
        cidr_block   = "10.0.1.0/24"
        vswitch_name = "bj_vswitch_1"
      },
      {
        zone_id      = "cn-beijing-j"
        cidr_block   = "10.0.2.0/24"
        vswitch_name = "bj_vswitch_2"
      }
    ],
    tr_vpc_attachment = {
      transit_router_attachment_name  = "bj_tr_attachment_name"
      auto_publish_route_enabled      = true
      route_table_propagation_enabled = true
      route_table_association_enabled = true
    },
  }]
}


variable "sh_vpc_config" {
  description = "The parameters of vpc resources in cn-shanghai."
  type = list(object({
    vpc               = map(string)
    vswitches         = list(map(string))
    tr_vpc_attachment = optional(map(string), {})
  }))
  default = [{
    vpc = {
      cidr_block = "10.0.0.0/16"
    },
    vswitches = [
      {
        zone_id      = "cn-shanghai-e"
        cidr_block   = "10.0.1.0/24"
        vswitch_name = "sh_vswitch_1"
      },
      {
        zone_id      = "cn-shanghai-f"
        cidr_block   = "10.0.2.0/24"
        vswitch_name = "sh_vswitch_2"
      }
    ],
    tr_vpc_attachment = {
      transit_router_attachment_name  = "sh_tr_attachment_name"
      auto_publish_route_enabled      = true
      route_table_propagation_enabled = true
      route_table_association_enabled = true
    },
  }]
}
