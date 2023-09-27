output "accounts" {
  value = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "org_roots" {
  value = aws_organizations_organization.org.roots
}

output "org_arn" {
  value = aws_organizations_organization.org.arn
}

output "org_id" {
  value = aws_organizations_organization.org.id
}

output "master_account_arn" {
  value = aws_organizations_organization.org.master_account_arn
}