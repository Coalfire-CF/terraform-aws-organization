data "aws_iam_policy_document" "PreventVPCFlowLogDeletion" {
  statement {
    effect    = "Deny"
    resources = ["*"]

    actions = [
      "ec2:DeleteFlowLogs",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream",
    ]
  }
}