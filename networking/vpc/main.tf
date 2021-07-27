locals {
  az_tier_map = flatten([
    for az in var.azs : [
      for tier in var.tiers : {
        az   = az
        tier = tier
      }
    ]
  ])

  newbits = ceil(
    log(
      (length(var.azs) + var.reserved_azs) *
      (length(var.tiers) + var.reserved_tiers),
    2)
  )

  any_public_subnets = anytrue([for tier in var.tiers : tier.public ? true : false])
}

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = var.assign_ipv6
  tags                             = { Name = var.name }
}

resource "aws_subnet" "subnets" {
  count = length(local.az_tier_map)

  availability_zone = local.az_tier_map[count.index].az
  cidr_block        = cidrsubnet(var.vpc_cidr, local.newbits, count.index)
  vpc_id            = aws_vpc.main.id
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, local.newbits * 2, count.index)

  map_public_ip_on_launch = local.az_tier_map[count.index].tier.public

  tags = {
    Name   = "${local.az_tier_map[count.index].az}-${local.az_tier_map[count.index].tier.name}"
    Public = local.az_tier_map[count.index].tier.public
  }
}

resource "aws_internet_gateway" "igw" {
  count = local.any_public_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = local.any_public_subnets ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}_public_subnet_route_table"
  }
}

resource "aws_route" "ipv4_public_route" {
  count                  = local.any_public_subnets ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public_route_assoc" {
  for_each       = toset([for az_tier in local.az_tier_map : "${az_tier.az}-${az_tier.tier.name}" if az_tier.tier.public])
  subnet_id      = [for subnet in aws_subnet.subnets : subnet.id if subnet.tags.Name == each.value][0]
  route_table_id = aws_route_table.public_route_table[0].id
}
