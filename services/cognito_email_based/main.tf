resource "aws_cognito_user_pool" "custom" {
  name = var.name

  username_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message_by_link = "${var.verification_email_message}.\nClick {##HERE##} to verify your email"
    email_subject_by_link = var.verification_email_subject
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn            = var.ses_email_arn
  }

  tags = {
    key   = "Name"
    value = "${var.name}-cognito-user-pool"
  }
}