data "aws_iam_policy_document" "MFARequiredChanges" {
  statement {
    sid       = "DenyActionsWhenMFAIsNotPresent"
    effect    = "Deny"
    resources = ["*"]

    ## More services can be added below to now be allowed if the user performing them doesn't have MFA present on their user
    actions = [
      "ec2:StopInstances",
      "ec2:TerminateInstances",
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}