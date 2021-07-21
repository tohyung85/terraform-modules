variable "alb_name" {
  description = "The name to use for this alb"
  type        = string
}

variable "subnet_ids" {
  description = "The subnets where ALB will route traffic to"
  type        = list(string)
}
