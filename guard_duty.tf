resource "aws_guardduty_organization_admin_account" "gh_admin_account" {
  count = var.create_org_guardduty ? 1 : 0

  depends_on = [aws_organizations_organization.org]


  admin_account_id = var.delegated_admin_account_id
}

resource "aws_guardduty_detector" "guardduty" {
  count = var.create_org_guardduty ? 1 : 0

  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.aws_guardduty_datasources_enable_S3
    }
    kubernetes {
      audit_logs {
        enable = var.aws_guardduty_datasources_enable_k8_audit_logs
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.aws_guardduty_datasources_enable_malware_protection_ebs
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "guardduty" {
  count = var.create_org_guardduty ? 1 : 0

  name = "/aws/guardduty/logs"
}

resource "aws_guardduty_organization_configuration" "guardduty" {
  count = var.create_org_guardduty ? 1 : 0
  auto_enable = true
  auto_enable_organization_members = "ALL"
  detector_id                      = aws_guardduty_detector.guardduty[0].id

  datasources {
    s3_logs {
      auto_enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = true
        }
      }
    }
  }

}

data "aws_iam_policy_document" "bucket_pol" {
  count = var.create_org_guardduty ? 1 : 0

  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.gd_bucket[0].arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow GetBucketLocation"
    actions = [
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.gd_bucket[0].arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kms_pol" {
  count = var.create_org_guardduty ? 1 : 0

  statement {
    sid = "Allow GuardDuty to encrypt findings"
    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow all users to modify/delete key"
    actions = [
      "kms:*"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

}

resource "aws_s3_bucket" "gd_bucket" {
  count = var.create_org_guardduty ? 1 : 0

  bucket        = "${var.resource_prefix}-${var.aws_region}-guardduty-findings"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "gd_bucket_policy" {
  count = var.create_org_guardduty ? 1 : 0

  bucket = aws_s3_bucket.gd_bucket[0].id
  policy = data.aws_iam_policy_document.bucket_pol[0].json
}

module "guardduty_kms_key" {
  count = var.create_org_guardduty ? 1 : 0
  source = "github.com/Coalfire-CF/terraform-aws-kms"

  key_policy            = data.aws_iam_policy_document.kms_pol[0].json
  kms_key_resource_type = "backup"
  resource_prefix       = var.resource_prefix
}


resource "aws_guardduty_publishing_destination" "gd_pub_dest" {
  count = var.create_org_guardduty ? 1 : 0

  detector_id     = aws_guardduty_detector.guardduty[0].id
  destination_arn = aws_s3_bucket.gd_bucket[0].arn
  kms_key_arn     = module.guardduty_kms_key.arn

  depends_on = [
    aws_s3_bucket_policy.gd_bucket_policy[0],
  ]
}