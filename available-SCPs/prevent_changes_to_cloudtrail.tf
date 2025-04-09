data "aws_iam_policy_document" "preventCloudtrailChanges" {
  statement {
    effect    = "Deny"
    resources = ["arn:aws:cloudtrail:${Region}:${Account}:trail/[CLOUDTRAIL_NAME]"] #name of the cloudtrail - can also be a wildcard #UPDATE PARTITIONS

    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:PutEventSelectors",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
    ]

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/[INFRASTRUCTURE_AUTOMATION_ROLE]"] # only role allowed to modify cloudtrail
    }
  }
}