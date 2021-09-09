output "autoscaling_group_arn" {
  value       = module.terraform_asg.autoscaling_group_arn
  description = "Created asg arn"
}
output "iam_instance_profile" {
  value       = module.ecs_iam_profile.iam_instance_profile_id
  description = "created iam instance profile id"
}
