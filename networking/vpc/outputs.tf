output "az_tier_map" {
  description = "Map of AZ and tiers"
  value       = local.az_tier_map
}

output "ipv6_cidr_block" {
  description = "IPv6 CIDR"
  value       = aws_vpc.main.ipv6_cidr_block
}

output "created_subnet_ids" {
  value = [for subnet in aws_subnet.subnets : { Name = "${subnet.tags.Name}"
  "Id" = subnet.id }]
  description = "Created subnet ids"
}

output "created_vpc_id" {
  value       = aws_vpc.main.id
  description = "Created VPC id"
}
