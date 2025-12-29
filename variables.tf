variable "aws_region" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "create_org_cloudtrail" {
  description = "True/False statement whether to enable AWS Cloudtrail in the Organization"
  type        = bool
}

variable "org_account_name" {
  description = "value to be used for the org account name"
  type        = string
}

variable "default_aws_region" {
  description = "The default AWS region to create resources in"
  type        = string
}

variable "account_number" {
  description = "The AWS account number resources are being deployed into"
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
}

variable "service_access_principals" {
  description = "List of AWS Service Access Principals that you want to enable for organization integration"
  type        = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
    "ssm.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "guardduty.amazonaws.com",
    "controltower.amazonaws.com",
    "securityhub.amazonaws.com",
    "ram.amazonaws.com",
    "tagpolicies.tag.amazonaws.com"
  ]
}

variable "feature_set" {
  description = "Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED_BILLING."
  default     = "ALL"
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable in the Organization Root. Organization must have feature_set set to ALL. For additional information about valid policy types (e.g., AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY, and TAG_POLICY)"
  type        = list(string)
  default     = [""]
}