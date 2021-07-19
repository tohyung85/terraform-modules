resource "aws_db_instance" "example" {
  identifier_prefix = var.db_instance_prefix
  engine = "mysql"
  allocated_storage = var.db_allocated_storage
  instance_class = var.db_instance_type
  name = var.db_name
  username = "admin"
  skip_final_snapshot = true

  # Create 
  password = var.db_password
}
