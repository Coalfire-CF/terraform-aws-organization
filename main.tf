resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_access_principals

  feature_set = var.feature_set

  #enabled_policy_types = var.enabled_policy_types # I want to implement this based off a check of feature_set - if not set to ALL then this is null.
}

resource "aws_organizations_delegated_administrator" "delegated_admin" {
  for_each = var.delegated_account_id
  account_id        = each.value
  service_principal = var.delegated_service_principal[each.index]
}

resource "aws_organizations_account" "account" {
  for_each  = var.aws_new_member_account_email
  name  = var.aws_new_member_account_name[each.index]
  email = each.value
}

