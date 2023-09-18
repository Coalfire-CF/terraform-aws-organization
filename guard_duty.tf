data "aws_caller_identity" "current" {}


resource "aws_guardduty_organization_admin_account" "example" {
  depends_on = [aws_organizations_organization.org]

  admin_account_id = var.delegated_admin_account_id
}

resource "aws_guardduty_detector" "guardduty" {
  enable = true
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
  name              = "/aws/guardduty/logs"
}

resource "aws_guardduty_organization_configuration" "guardduty" {
  auto_enable_organization_members = "ALL"
  detector_id = aws_guardduty_detector.guardduty.id
}

data "aws_iam_policy_document" "bucket_pol" {
  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
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
      aws_s3_bucket.gd_bucket.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kms_pol" {

  statement {
    sid = "Allow GuardDuty to encrypt findings"
    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [
      "arn:${var.partition}:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
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
      "arn:${var.partition}:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

}

resource "aws_s3_bucket" "gd_bucket" {
  bucket        = "${var.resource_prefix}-${var.aws_region}-guardduty-findings"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "gd_bucket_acl" {
  bucket = aws_s3_bucket.gd_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "gd_bucket_policy" {
  bucket = aws_s3_bucket.gd_bucket.id
  policy = data.aws_iam_policy_document.bucket_pol.json
}

resource "aws_kms_key" "gd_key" {
  description             = "kms key for guardduty"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.kms_pol.json
}

resource "aws_guardduty_publishing_destination" "gd_pub_dest" {
  detector_id     = aws_guardduty_detector.guardduty.id
  destination_arn = aws_s3_bucket.gd_bucket.arn
  kms_key_arn     = aws_kms_key.gd_key.arn

  depends_on = [
    aws_s3_bucket_policy.gd_bucket_policy,
  ]
}