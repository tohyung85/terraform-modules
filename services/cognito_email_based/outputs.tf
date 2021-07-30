output "user_pool_arn" {
  value = aws_cognito_user_pool.custom.arn
  description = "ARN of created user pool"
}

output "user_pool_id" {
  value = aws_cognito_user_pool.custom.id
  description = "ID of created user pool"
}
