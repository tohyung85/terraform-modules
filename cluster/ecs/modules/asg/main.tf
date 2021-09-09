#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
module "ecs_iam_profile" {
  source = "../ecs-iam-profile"
  name   = "${var.name}-ecs"
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_subnet" "first" {
  id = var.asg_subnets[0]
}

data "aws_security_group" "vpc_sg" {
  vpc_id = data.aws_subnet.first.vpc_id
  name   = "default"
}

data "template_file" "user_data" {
  template = file("./user-data.sh")

  vars = {
    cluster_name = var.name
  }
}

module "terraform_asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  # source  = "HDE/autoscaling/aws"
  version = "~> 4.0"

  name = var.name

  # Launch configuration
  lc_name   = var.name
  use_lc    = true
  create_lc = true

  image_id                  = data.aws_ami.amazon_linux_ecs.id
  instance_type             = var.instance_type
  security_groups           = [data.aws_security_group.vpc_sg.id]
  iam_instance_profile_name = module.ecs_iam_profile.iam_instance_profile_id
  user_data                 = data.template_file.user_data.rendered

  # Auto scaling group
  vpc_zone_identifier       = var.asg_subnets
  health_check_type         = "EC2"
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity          = var.asg_desired
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Cluster"
      value               = var.name
      propagate_at_launch = true
    },
  ]
}
