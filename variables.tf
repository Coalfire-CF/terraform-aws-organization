variable "service_access_principals" {
  description = "List of AWS Service Access Prinicpals that you want to enable for organization integration"
  type = list(string)
}

variable "feature_set" {
  description = "Feature set to be used with Org and member accounts Specify ALL(default) or CONSOLIDATED_BILLING."
  default = "ALL"
}

variable "delegated_account_id" {
  description = "The account ID number of the member account in the organization to register as a delegated administrator."
  type = list(string)
  default = null
}

variable "delegated_service_principal" {
  description = "The service principal of the AWS service for which you want to make the member account a delegated administrator."
  default = null
}

variable "aws_new_member_account_name" {
  description = "The Friendly name for the member account."
  default = null
}

variable "aws_new_member_account_email" {
  description = "The Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account."
  default = null
}