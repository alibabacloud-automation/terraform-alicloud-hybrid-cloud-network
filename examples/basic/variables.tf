# vpc、vswitch 参数
variable "vpc_config" {
  description = "The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc               = map(string)
    vswitches         = list(map(string))
    tr_vpc_attachment = optional(map(string), {})
  }))
  default = [
    {
      vpc = {
        cidr_block = "10.0.0.0/16"
      },
      vswitches = [
        {
          zone_id    = "cn-hangzhou-i"
          cidr_block = "10.0.1.0/24"
        },
        {
          zone_id    = "cn-hangzhou-j"
          cidr_block = "10.0.2.0/24"
        }
      ],
    },
  ]
}


