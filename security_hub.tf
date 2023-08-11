resource "aws_securityhub_organization_admin_account" "sechub_org_admin" {

  depends_on = [aws_organizations_organization.org]

  admin_account_id = aws_organizations_organization.org.master_account_id
}

resource "aws_securityhub_organization_configuration" "sechub_org_config" {
  auto_enable = true
}

resource "aws_securityhub_standards_subscription" "cis" {
  for_each = var.aws_sec_hub_standards_arn
  depends_on    = [aws_securityhub_organization_admin_account.sechub_org_admin]
  standards_arn = each.value
}

