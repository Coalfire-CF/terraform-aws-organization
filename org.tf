resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_access_principals

  feature_set = var.feature_set
  enabled_policy_types = var.enabled_policy_types
}

#resource "aws_organizations_delegated_administrator" "delegated" {
#  depends_on = [aws_organizations_organization.org-creation]
#
#  account_id        = var.delegated_admin_account_id
#  service_principal = var.delegated_service_principal
#}


resource "aws_organizations_policy" "scp" {
  content = data.aws_iam_policy_document.scp.json
  name = "FedModGovSCP"
}

resource "aws_organizations_policy_attachment" "scp" {
  policy_id = aws_organizations_policy.scp.id
  target_id = aws_organizations_organization.org.roots[0].id
}
