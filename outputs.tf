output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = aws_organizations_organization.org.master_account_id
  description = "Master account ID"
}

output "s3_cloudtrail_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = "${var.resource_prefix}-${var.aws_region}-org-cloudtrail"
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = aws_cloudtrail.org-trail[0].arn
}

output "s3_cloudtrail_arn" {
  value = aws_cloudtrail.org-trail[0].arn
}