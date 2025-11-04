resource "aws_organizations_organization" "org" {
  depends_on                    = [module.account_setup]
  aws_service_access_principals = var.service_access_principals

  feature_set          = var.feature_set
  enabled_policy_types = var.enabled_policy_types
}

