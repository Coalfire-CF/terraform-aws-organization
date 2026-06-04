variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "is_gov" {
  description = "Whether or not the environment is being deployed in GovCloud"
  type        = bool
}

variable "default_aws_region" {
  description = "The default AWS region to create resources in"
  type        = string
}

# variable "account_number" {
#   description = "The AWS account number resources are being deployed into"
#   type        = string
# }

variable "resource_prefix" {
  description = "The prefix for resources"
  type        = string
}

variable "create_cloudtrail" {
  description = "Whether or not to create cloudtrail resources"
  type        = bool
}

variable "is_organization" {
  description = "Whether or not to enable certain settings for AWS Organization"
  type        = bool
}

variable "organization_id" {
  description = "AWS Organization ID"
  type        = string
  default     = null
}

variable "create_org_cloudtrail" {
  description = "True/False statement whether to enable AWS Cloudtrail in the Organization"
  type        = bool
}