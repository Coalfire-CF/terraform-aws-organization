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

variable "mgmt_account_id" {
  description = "Account ID if the MGMT plane"
  type = string
}

# variable "delegated_admin_account_id" {
#   description = "The account ID number of the member account in the organization to register as a delegated administrator."
#   type        = list(string)
#   default     = null
# }

# variable "delegated_service_principal" {
#   description = "The service principal of the AWS service for which you want to make the member account a delegated administrator."
#   default     = "principal"
# }

# variable "aws_new_member_account_name" {
#   description = "The Friendly name for the member account."
#   default     = null
# }

# variable "aws_new_member_account_email" {
#   description = "The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account."
#   default     = null
# }

# variable "ou_creation_info" {
#   description = "list of names of OU to create and their corresponding delegated admins"
#   type        = map(map(string))
#   default = {
#     ou1 = {
#       ou_name      = "mgmt_ou"
#       ou_parent_id = "parent_id1"
#     },
#     ou2 = {
#       ou_name      = "app_ou"
#       ou_parent_id = "parent_id2"
#     }
#   }
# }