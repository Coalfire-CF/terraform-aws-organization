output "accounts" {
  value       = aws_organizations_organization.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = aws_organizations_organization.org.master_account_id
  description = "Master account ID"
}

output "org_id" {
  value       = aws_organizations_organization.org.id
  description = "Organization ID"
}

output "s3_access_logs_arn" {
  value = try(module.account_setup.s3_access_logs_arn, null)
}

output "s3_elb_access_logs_arn" {
  value = try(module.account_setup.s3_elb_access_logs_arn, null)
}

output "s3_backups_arn" {
  value = try(module.account_setup.s3_backups_arn, null)
}

output "s3_installs_arn" {
  value = try(module.account_setup.s3_installs_arn, null)
}

output "s3_cloudtrail_arn" {
  value = try(module.account_setup.s3_cloudtrail_arn, null)
}

output "s3_fedrampdoc_arn" {
  value = try(module.account_setup.s3_fedrampdoc_arn, null)
}

output "s3_config_arn" {
  value = try(module.account_setup.s3_config_arn, null)
}

output "s3_access_logs_id" {
  value = try(module.account_setup.s3_access_logs_id, null)
}

output "s3_elb_access_logs_id" {
  value = try(module.account_setup.s3_elb_access_logs_id, null)
}

output "s3_backups_id" {
  value = try(module.account_setup.s3_backups_id, null)
}

output "s3_installs_id" {
  value = try(module.account_setup.s3_installs_id, null)
}

output "s3_cloudtrail_id" {
  value = try(module.account_setup.s3_cloudtrail_id, null)
}

output "s3_fedrampdoc_id" {
  value = try(module.account_setup.s3_fedrampdoc_id, null)
}

output "s3_config_id" {
  value = try(module.account_setup.s3_config_id, null)
}

output "s3_kms_key_arn" {
  value = try(module.account_setup.s3_kms_key_arn, null)
}

output "s3_kms_key_id" {
  value = try(module.account_setup.s3_kms_key_id, null)
}

output "dynamo_kms_key_arn" {
  value = try(module.account_setup.dynamo_kms_key_arn, null)
}

output "dynamo_kms_key_id" {
  value = try(module.account_setup.dynamo_kms_key_id, null)
}

output "ebs_kms_key_arn" {
  value = try(module.account_setup.ebs_kms_key_arn, null)
}

output "ebs_kms_key_id" {
  value = try(module.account_setup.ebs_kms_key_id, null)
}

output "sm_kms_key_arn" {
  value = try(module.account_setup.sm_kms_key_arn, null)
}

output "sm_kms_key_id" {
  value = try(module.account_setup.sm_kms_key_id, null)
}

output "backup_kms_key_arn" {
  value = try(module.account_setup.backup_kms_key_arn, null)
}

output "backup_kms_key_id" {
  value = try(module.account_setup.backup_kms_key_id, null)
}

output "lambda_kms_key_arn" {
  value = try(module.account_setup.lambda_kms_key_arn, null)
}

output "lambda_kms_key_id" {
  value = try(module.account_setup.lambda_kms_key_id, null)
}

output "rds_kms_key_arn" {
  value = try(module.account_setup.rds_kms_key_arn, null)
}

output "rds_kms_key_id" {
  value = try(module.account_setup.rds_kms_key_id, null)
}

output "sns_kms_key_id" {
  value = try(module.account_setup.sns_kms_key_id, null)
}

output "sns_kms_key_arn" {
  value = try(module.account_setup.sns_kms_key_arn, null)
}

output "cloudwatch_kms_key_arn" {
  value = try(module.account_setup.cloudwatch_kms_key_arn, null)
}

output "cloudwatch_kms_key_id" {
  value = try(module.account_setup.cloudwatch_kms_key_id, null)
}

output "config_kms_key_arn" {
  value = try(module.account_setup.config_kms_key_arn, null)
}

output "config_kms_key_id" {
  value = try(module.account_setup.config_kms_key_id, null)
}

output "nfw_kms_key_arn" {
  value = try(module.account_setup.nfw_kms_key_arn, null)
}

output "nfw_kms_key_id" {
  value = try(module.account_setup.nfw_kms_key_id, null)
}

output "additional_kms_key_arns" {
  value = try(module.account_setup.additional_kms_key_arns, null)
}

output "additional_kms_key_ids" {
  value = try(module.account_setup.additional_kms_key_ids, null)
}

output "s3_tstate_bucket_name" {
  value = try(module.account_setup.s3_tstate_bucket_name, null)
}

output "dynamodb_table_name" {
  value = try(module.account_setup.dynamodb_table_name, null)
}

output "packer_iam_role_arn" {
  value = try(module.account_setup.packer_iam_role_arn, null)
}

output "packer_iam_role_name" {
  value = try(module.account_setup.packer_iam_role_name, null)
}

output "eks_node_role_arn" {
  value = try(module.account_setup.eks_node_role_arn, null)
}
output "eks_node_role_name" {
  value = try(module.account_setup.eks_node_role_name, null)
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

