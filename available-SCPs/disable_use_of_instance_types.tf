data "aws_iam_policy_document" "DenyBurstableEC2" {
  statement {
    sid       = "DenyBurtsableInstanceType"
    effect    = "Deny"
    resources = ["arn:aws:ec2:*:*:instance/*"] #UPDATE PARTITIONS
    actions   = ["ec2:RunInstances"]

    condition {
      test     = "StringEquals"
      variable = "ec2:InstanceType"
      values   = ["t2*", "t3*", "t4*"]
    }
  }
}