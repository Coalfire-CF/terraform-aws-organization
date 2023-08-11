resource "aws_config_configuration_aggregator" "organization" {
  depends_on = [aws_iam_role_policy_attachment.organization]

  name = "${var.resource_prefix}-org-aggregator" # Required

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.aws_config_org_role.arn
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "aws_config_org_role" {
  name               = "org-config-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "organization" {
  role       = aws_iam_role.aws_config_org_role.name
  policy_arn = "arn:${var.partition}:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}