variable "db_instance_prefix" {
  description = "Identified prefix for database instance"
  type = string
}

variable "db_instance_type" {
  description = "DB Instance type. e.g. db.t2.micro"
  type = string
}

variable "db_name" {
  description = "Name of database"
  type = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type = number
}

variable "db_password" {
  description = "DB Password"
  type = string
}