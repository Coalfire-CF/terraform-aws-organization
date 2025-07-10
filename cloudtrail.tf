resource "aws_cloudtrail" "org-trail" {
  depends_on = [module.account-setup]
  count      = var.create_org_cloudtrail ? 1 : 0

  name                       = "${var.resource_prefix}-org-cloudtrail"
  s3_bucket_name             = "${var.resource_prefix}-${var.aws_region}-cloudtrail"
  kms_key_id                 = module.account-setup.s3_kms_key_arn
  enable_log_file_validation = true
  is_multi_region_trail      = true

  is_organization_trail = true
}