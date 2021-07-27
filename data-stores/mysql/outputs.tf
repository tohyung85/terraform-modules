output "address" {
  value       = length(var.subnet_ids) > 0 ? aws_db_instance.db_custom_subnet[0].address : aws_db_instance.db_default_subnet[0].address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = length(var.subnet_ids) > 0 ? aws_db_instance.db_custom_subnet[0].port : aws_db_instance.db_default_subnet[0].port
  description = "The port the database is listening on"
}
