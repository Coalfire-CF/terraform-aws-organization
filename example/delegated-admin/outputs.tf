output "accounts" {
  value       = module.org.accounts
  description = "List of org accounts including master"
}

output "master_account_id" {
  value       = module.org.master_account_id
  description = "Master account ID"
}

output "org_id" {
  value       = module.org.org_id
  description = "Organization ID"
}

output "s3_access_logs_arn" {
  value = try(module.org.s3_access_logs_arn, null)
}

output "s3_elb_access_logs_arn" {
  value = try(module.org.s3_elb_access_logs_arn, null)
}

output "s3_backups_arn" {
  value = try(module.org.s3_backups_arn, null)
}

output "s3_installs_arn" {
  value = try(module.org.s3_installs_arn, null)
}

output "s3_cloudtrail_arn" {
  value = try(module.org.s3_cloudtrail_arn, null)
}

output "s3_fedrampdoc_arn" {
  value = try(module.org.s3_fedrampdoc_arn, null)
}

output "s3_config_arn" {
  value = try(module.org.s3_config_arn, null)
}

output "s3_access_logs_id" {
  value = try(module.org.s3_access_logs_id, null)
}

output "s3_elb_access_logs_id" {
  value = try(module.org.s3_elb_access_logs_id, null)
}

output "s3_backups_id" {
  value = try(module.org.s3_backups_id, null)
}

output "s3_installs_id" {
  value = try(module.org.s3_installs_id, null)
}

output "s3_cloudtrail_id" {
  value = try(module.org.s3_cloudtrail_id, null)
}

output "s3_fedrampdoc_id" {
  value = try(module.org.s3_fedrampdoc_id, null)
}

output "s3_config_id" {
  value = try(module.org.s3_config_id, null)
}

output "s3_kms_key_arn" {
  value = try(module.org.s3_kms_key_arn, null)
}

output "s3_kms_key_id" {
  value = try(module.org.s3_kms_key_id, null)
}

output "dynamo_kms_key_arn" {
  value = try(module.org.dynamo_kms_key_arn, null)
}

output "dynamo_kms_key_id" {
  value = try(module.org.dynamo_kms_key_id, null)
}

output "ebs_kms_key_arn" {
  value = try(module.org.ebs_kms_key_arn, null)
}

output "ebs_kms_key_id" {
  value = try(module.org.ebs_kms_key_id, null)
}

output "sm_kms_key_arn" {
  value = try(module.org.sm_kms_key_arn, null)
}

output "sm_kms_key_id" {
  value = try(module.org.sm_kms_key_id, null)
}

output "backup_kms_key_arn" {
  value = try(module.org.backup_kms_key_arn, null)
}

output "backup_kms_key_id" {
  value = try(module.org.backup_kms_key_id, null)
}

output "lambda_kms_key_arn" {
  value = try(module.org.lambda_kms_key_arn, null)
}

output "lambda_kms_key_id" {
  value = try(module.org.lambda_kms_key_id, null)
}

output "rds_kms_key_arn" {
  value = try(module.org.rds_kms_key_arn, null)
}

output "rds_kms_key_id" {
  value = try(module.org.rds_kms_key_id, null)
}

output "sns_kms_key_id" {
  value = try(module.org.sns_kms_key_id, null)
}

output "sns_kms_key_arn" {
  value = try(module.org.sns_kms_key_arn, null)
}

output "cloudwatch_kms_key_arn" {
  value = try(module.org.cloudwatch_kms_key_arn, null)
}

output "cloudwatch_kms_key_id" {
  value = try(module.org.cloudwatch_kms_key_id, null)
}

output "config_kms_key_arn" {
  value = try(module.org.config_kms_key_arn, null)
}

output "config_kms_key_id" {
  value = try(module.org.config_kms_key_id, null)
}

output "nfw_kms_key_arn" {
  value = try(module.org.nfw_kms_key_arn, null)
}

output "nfw_kms_key_id" {
  value = try(module.org.nfw_kms_key_id, null)
}

output "additional_kms_key_arns" {
  value = try(module.org.additional_kms_key_arns, null)
}

output "additional_kms_key_ids" {
  value = try(module.org.additional_kms_key_ids, null)
}

output "s3_tstate_bucket_name" {
  value = try(module.org.s3_tstate_bucket_name, null)
}

output "dynamodb_table_name" {
  value = try(module.org.dynamodb_table_name, null)
}

output "packer_iam_role_arn" {
  value = try(module.org.packer_iam_role_arn, null)
}

output "packer_iam_role_name" {
  value = try(module.org.packer_iam_role_name, null)
}

output "eks_node_role_arn" {
  value = try(module.org.eks_node_role_arn, null)
}

output "eks_node_role_name" {
  value = try(module.org.eks_node_role_name, null)
}