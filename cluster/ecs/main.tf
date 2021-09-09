module "asg" {
  source = "./modules/asg"

  name = var.name

  asg_subnets = var.subnets

  instance_type = var.instance_type

  asg_min     = var.asg_min
  asg_max     = var.asg_max
  asg_desired = var.asg_desired
}

resource "aws_ecs_capacity_provider" "asg_prov" {
  name = "asg_prov"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }
}

resource "aws_ecs_cluster" "this" {
  name = var.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.asg_prov.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_prov.name
    weight            = "1"
  }

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  tags = var.tags
}
