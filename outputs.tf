output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

resource "aws_organizations_delegated_administrator" "delegated" {
  account_id        = var.delegated_account_id
  service_principal = var.delegated_service_principal
}
