data "aws_iam_policy_document" "DenyLeaveOrg" {
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions   = ["organizations:LeaveOrganization"]
  }
}