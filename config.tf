resource "aws_config_configuration_aggregator" "organization" {
  count      = var.create_org_config ? 1 : 0
  depends_on = [aws_iam_role_policy_attachment.organization]

  name = "${var.resource_prefix}-org-aggregator" # Required

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.aws_config_org_role.arn
  }
}
