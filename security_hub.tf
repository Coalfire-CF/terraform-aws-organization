resource "aws_securityhub_organization_admin_account" "sechub_org_admin" {
  count = var.create_org_securityhub ? 1 : 0
  depends_on = [aws_organizations_organization.org]

  admin_account_id = aws_organizations_organization.org.master_account_id
}

resource "aws_securityhub_organization_configuration" "sechub_org_config" {
  count = var.create_org_securityhub ? 1 : 0

  auto_enable = true
}

resource "aws_securityhub_standards_subscription" "cis" {
  for_each = var.aws_sec_hub_standards_arn
  depends_on    = [aws_securityhub_organization_admin_account.sechub_org_admin[0]]
  standards_arn = each.value
}

