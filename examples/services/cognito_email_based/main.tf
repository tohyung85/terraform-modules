terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Make use of remote state to get ses arn

# data "terraform_remote_state" "ses" {
#   backend = "s3"

#   config = {
#     bucket = ses_remote_state_bucket
#     key    = ses_remote_state_key
#     region = "us-east-1"
#   }
# }

module "cognito" {
  source = "../../../services/cognito_email_based"

  name = "example"

  ses_email_arn = "arn:aws:ses:us-east-1:XXXXXX:identity/youremail@domain.com"
  # Make use of remote state to get SES ARN
  # ses_email_arn = data.terraform_remote_state.ses.arn

  # Optionals
  verification_email_message = "Welcome to my world"
  verification_email_subject = "Hello There"
}
