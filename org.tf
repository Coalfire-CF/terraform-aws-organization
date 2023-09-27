resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_access_principals

  feature_set = var.feature_set

  #enabled_policy_types = var.enabled_policy_types # I want to implement this based off a check of feature_set - if not set to ALL then this is null.
}

resource "aws_organizations_delegated_administrator" "delegated" {
  account_id        = var.delegated_admin_account_id
  service_principal = var.delegated_service_principal
}

resource "aws_organizations_account" "account" {
  count  = length(var.aws_new_member_account_email)
  name  = var.aws_new_member_account_name[count.index]
  email = var.aws_new_member_account_email[count.index]
}


resource "aws_organizations_policy" "scp" {
  content = data.aws_iam_policy_document.scp.json
  name = "FedModGovSCP"
}

resource "aws_organizations_policy_attachment" "scp" {
  policy_id = aws_organizations_policy.scp.id
  target_id = aws_organizations_organization.org.id
}
