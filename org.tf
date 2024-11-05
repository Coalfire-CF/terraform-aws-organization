resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.service_access_principals

  feature_set          = var.feature_set
  enabled_policy_types = var.enabled_policy_types
}

# resource "aws_organizations_delegated_administrator" "delegated_admin" {
#   for_each = toset(var.delegated_admin_account_id)

#   account_id        = each.key
#   service_principal = var.delegated_service_principal
# }

# resource "aws_organizations_account" "account" {
#   for_each = toset(var.aws_new_member_account_email)

#   name  = var.org_account_name
#   email = each.value
# }

# resource "aws_organizations_organizational_unit" "ou" {
#   for_each = var.ou_creation_info

#   name      = each.value["ou_name"]
#   parent_id = each.value["ou_parent_id"]
# }

# resource "aws_organizations_policy" "scp" {
#   content = data.aws_iam_policy_document.scp.json
#   name    = "FedModGovSCP"
# }

# resource "aws_organizations_policy_attachment" "scp" {
#   policy_id = aws_organizations_policy.scp.id
#   target_id = aws_organizations_organization.org.id
# }


