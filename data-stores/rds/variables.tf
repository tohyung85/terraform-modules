variable "db_instance_prefix" {
  description = "Identified prefix for database instance"
  type        = string
}

variable "db_instance_type" {
  description = "DB Instance type. e.g. db.t2.micro"
  type        = string
}

variable "db_name" {
  description = "Name of database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "db_password" {
  description = "DB Password"
  type        = string
}

variable "publicly_accessible" {
  description = "If instance is accessible outside of instances within RDS VPC"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Subnet Ids to deploy DB into"
  type        = list(string)
  default     = []
}

variable "db_engine" {
  description = "DB Engine. MySQL, Postgres etc."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine Version"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "User name of admin"
  type        = string
  default     = "iamadmin"
}


