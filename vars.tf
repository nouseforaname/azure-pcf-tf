resource "random_string" "suffix" {
  length           = 8
  special          = false
}
variable "env_name" {
  type = string
  default = "dev"
}
variable "rg_name" {
  type = string
  default = "bc-test-kk"
} 

variable "net" {
  type = any
  default = {
    name = "pcf-virtual-network"
    cidr = "10.0.0.0/16"
    nsgs = {
      opsmgr-nsg = {
        rules = {
          http = {
            proto = "tcp",
            prio  = "100"
            dport_range = 80
          },
          https = {
            proto = "tcp",
            prio  = "200"
            dport_range = 443
          },
          diego-ssh = {
            proto = "tcp",
            prio  = "300"
            dport_range = 2222
          },
        }
      },
      pcf-nsg = {
        rules = {
          http = {
            proto = "tcp",
            prio  = "100"
            dport_range = 80
          },
          https = {
            proto = "tcp",
            prio  = "200"
            dport_range = 443
          },
          ssh = {
            proto = "tcp"
            prio  = "300"
            dport_range = 22
          },
        }
      },
      internal = {},
      azure_lb = {}

    }
    subnets = {
      a = {
        name = "net-mgmt"
        cidr = "10.0.1.0/24"
      }

    }
    

  }
}
variable "costcenter_tag" {
  type = string
  default = "it"
} 
variable "region" {
  type = string
  default = "WestUs"
} 
#variable "" {} 

