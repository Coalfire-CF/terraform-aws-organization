output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = aws_organizations_organization.org.master_account_id
  description = "Master account ID"
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.org-trail[0].arn
}

output "s3_cloudtrail_bucket_name" {
  value = "${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
}

output "s3_cloudtrail_bucket_arn" {
  value = "arn:aws:s3:::${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
}
