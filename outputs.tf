output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = aws_organizations_organization.org.master_account_id
  description = "Master account ID"
}

output "s3_cloudtrail_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail.arn
}