data "aws_iam_policy_document" "S3PublicAccessBlock" {
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions   = ["s3:PutAccountPublicAccessBlock"]

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/[ALLOWED_ROLE_NAME]"] # Role allowed to create public buckets - or condition could be removed if hard no.
    }
  }
}