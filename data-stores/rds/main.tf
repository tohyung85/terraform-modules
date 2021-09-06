resource "aws_db_instance" "db_custom_subnet" {
  count                  = length(var.subnet_ids) > 0 ? 1 : 0
  identifier_prefix      = var.db_instance_prefix
  engine                 = var.db_engine
  engine_version         = var.engine_version == "" ? null : var.engine_version
  allocated_storage      = var.db_allocated_storage
  instance_class         = var.db_instance_type
  name                   = var.db_name
  username               = var.db_username
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible
  db_subnet_group_name   = aws_db_subnet_group.example[0].id
  vpc_security_group_ids = length(var.db_security_groups) > 0 ? var.db_security_groups : null

  # Create 
  password = var.db_password
}

resource "aws_db_instance" "db_default_subnet" {
  count                  = length(var.subnet_ids) > 0 ? 0 : 1
  identifier_prefix      = var.db_instance_prefix
  engine                 = var.db_engine
  engine_version         = var.engine_version == "" ? null : var.engine_version
  allocated_storage      = var.db_allocated_storage
  instance_class         = var.db_instance_type
  name                   = var.db_name
  username               = var.db_username
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = length(var.db_security_groups) > 0 ? var.db_security_groups : null

  # Create 
  password = var.db_password
}

resource "aws_db_subnet_group" "example" {
  count      = length(var.subnet_ids) > 0 ? 1 : 0
  name       = var.db_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name} subnet group"
  }
}
