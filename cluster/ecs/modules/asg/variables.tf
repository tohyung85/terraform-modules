variable "name" {
  type        = string
  description = "Name of ASG"
}

variable "asg_subnets" {
  type        = list(string)
  description = "ASG Subnets"
}

variable "instance_type" {
  type        = string
  description = "Instance type of ASG"
}

variable "asg_min" {
  type        = number
  description = "Min instances in ASG"
  default     = 0
}

variable "asg_max" {
  type        = number
  description = "Max instances in ASG"
  default     = 1
}

variable "asg_desired" {
  type        = number
  description = "Desired no. of instances in ASG"
  default     = 0
}
