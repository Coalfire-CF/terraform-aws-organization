resource "aws_cloudtrail" "org-trail" {
  count = var.create_org_cloudtrail ? 1 : 0

  name                       = "${var.resource_prefix}-org-cloudtrail"
  s3_bucket_name             = "${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
  kms_key_id                 = var.s3_kms_key_arn
  enable_log_file_validation = true
  is_multi_region_trail      = true

  is_organization_trail = true
}