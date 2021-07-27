variable "name" {
  type        = string
  description = "VPC Name"
}

variable "azs" {
  type        = list(string)
  description = "Number of Availability Zones which VPC will cover"
}

variable "tiers" {
  type = list(object({
    name   = string
    public = bool
  }))
  description = "Number of application tiers within each AZ"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC Network CIDR prefix"
  default     = "10.16.0.0/16"
}

variable "assign_ipv6" {
  type        = bool
  description = "Allow AWS to assign an IPv6 CIDR block"
  default     = true
}

variable "reserved_azs" {
  type        = number
  description = "Number of reserved tiers per AZ (including reserved AZ). E.g For a value of 1 and 3 + 1 reserved Tiers specified, 4 * 1 subnet cidrs will be set aside for future use"
  default     = 0
}

variable "reserved_tiers" {
  type        = number
  description = "Number of reserved tiers per AZ (including reserved AZ). E.g For a value of 1 and 3 + 1 reserved AZs specified, 4 * 1 subnet cidrs will be set aside for future use"
  default     = 0
}
