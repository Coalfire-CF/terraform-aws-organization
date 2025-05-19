data "aws_iam_policy_document" "DenyNonUSAWS" {
  statement {
    sid       = "DenyAllOutsideUS"
    effect    = "Deny"
    resources = ["*"]

    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "route53-recovery-cluster:*",
      "route53-recovery-control-config:*",
      "route53-recovery-readiness:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:ListMultiRegionAccessPoints",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*"
    ]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion" # AWS Regions allowed to be accessed

      values = [
        "us-west-1",
        "us-west-2",
        "us-east-1",
        "us-east-2",
      ]
    }

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/Role1AllowedToBypassThisSCP"] # roles allowed to bypass this SCP
    }
  }
}