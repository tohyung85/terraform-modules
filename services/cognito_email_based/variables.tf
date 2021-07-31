variable "name" {
  type        = string
  description = "Name of user pool"
}

variable "verification_email_message" {
  type        = string
  description = "Email body of the sign up verification email."
  default     = "Welcome and thank you for signing up!"
}

variable "verification_email_subject" {
  type        = string
  description = "Email subject of the sign up verification email."
  default     = "Almost there! Verify your email"
}

variable "ses_email_arn" {
  type        = string
  description = "Email account for sending of emails by Cognito. This email must be created in SES and verified."
}
