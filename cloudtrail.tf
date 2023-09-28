resource "aws_cloudtrail" "org-trail" {
  depends_on = [aws_organizations_organization.org, aws_s3_bucket.cloudtrail]
  count = var.create_org_cloudtrail ? 1 : 0

  name = "${var.resource_prefix}-org-cloudtrail"
  s3_bucket_name = "${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
  kms_key_id = var.s3_kms_key_arn
  enable_log_file_validation    = true
  is_multi_region_trail         = true

  is_organization_trail = true
}

resource "aws_s3_bucket" "cloudtrail" {
  count  = var.create_org_cloudtrail && var.aws_region == var.aws_region ? 1 : 0
  bucket = "${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail-encryption" {
  count  = var.create_org_cloudtrail && var.aws_region == var.aws_region ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket
  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = var.s3_kms_key_arn
      }
    }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  count  = var.create_org_cloudtrail && var.aws_region == var.aws_region ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].bucket

  policy = data.aws_iam_policy_document.log_bucket_policy.json
}

data "aws_iam_policy_document" "log_bucket_policy" {
  statement {
    sid = "AWSCloudTrailWrite"
    actions = [
    "s3:PutObject"]
    effect = "Allow"
    principals {
      identifiers = [
      "cloudtrail.amazonaws.com"]
      type = "Service"
    }
    resources = ["${aws_s3_bucket.cloudtrail[0].arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AWSCloudTrailAclCheck"
    actions = [
    "s3:GetBucketAcl"]
    effect = "Allow"
    principals {
      identifiers = [
      "cloudtrail.amazonaws.com"]
      type = "Service"
    }
    resources = [
    aws_s3_bucket.cloudtrail[0].arn]
  }

  statement {
    sid     = "Stmt1546879543826"
    actions = ["s3:GetObject"]
    effect  = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
    resources = ["${aws_s3_bucket.cloudtrail[0].arn}/*"]
  }

  dynamic "statement" {
    for_each = var.org_member_account_numbers
    content {
      #sid = "AgencyAWSCloudTrailWrite"
      actions = ["s3:PutObject"]
      effect  = "Allow"
      principals {
        identifiers = [statement.value]
        type        = "AWS"
      }
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
      resources = ["${aws_s3_bucket.cloudtrail[0].arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.org_member_account_numbers
    content {
      #sid = "AgencyAWSCloudTrailAclCheck"
      actions = ["s3:GetBucketAcl"]
      effect  = "Allow"
      principals {
        identifiers = [statement.value]
        type        = "AWS"
      }
      resources = [aws_s3_bucket.cloudtrail[0].arn]
    }
  }
}


resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail[0].id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}