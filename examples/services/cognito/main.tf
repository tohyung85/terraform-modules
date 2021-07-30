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

module "cognito" {
  source = "../../../services/cognito_email_based"

  name = "example"

  app_email             = "example@noreply.com"
  sending_email_address = "arealemail@gmail.com"

  # Optionals
  verification_email_message = "Welcome to my world"
  verification_email_subject = "Hello There"
}
