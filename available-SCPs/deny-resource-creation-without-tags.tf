data "aws_iam_policy_document" "DenyEC2WithoughTags" {
  # copy and paste the statement below to add more contitions for required tags
  statement {
    sid       = "DenyRunInstanceWithNoDataClassificationTag"
    effect    = "Deny"
    resources = ["arn:aws:ec2:*:*:instance/*"] #Update partitions
    actions   = ["ec2:RunInstances"]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/DataClassification" # This can be made to be any Tag
      values   = ["true"]
    }
  }
}