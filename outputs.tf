output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = aws_organizations_organization.org.master_account_id
  description = "Master account ID"
}
