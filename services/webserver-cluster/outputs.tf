output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "Domain name of the load balancer"
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "The name of the Autoscaling Group"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}

output "instance_security_group_id" {
  value = aws_security_group.instance.id
  description = "The ID of the Security Group attached to the instances"
}