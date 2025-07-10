module "account-setup" {
  source = "../terraform-aws-account-setup"

  aws_region         = var.aws_region
  default_aws_region = var.default_aws_region
  account_number     = var.account_number
  resource_prefix    = var.resource_prefix


  # Only create the security core components first
  create_security_core = true

  # Disable other components for initial deployment (this needs to be set to true after for cloudtrail and run again)
  create_cloudtrail = var.create_cloudtrail
  create_packer_iam = false

  # Set to false initially as organization doesn't exist yet
  is_organization = var.is_organization
  organization_id = var.organization_id

  # Keep the necessary KMS keys but disable others to simplify
  create_s3_kms_key     = true
  create_dynamo_kms_key = true
  create_ebs_kms_key    = false
  create_sns_kms_key    = false
  create_lambda_kms_key = false
  create_rds_kms_key    = false
  create_backup_kms_key = false
  create_ecr_kms_key    = false
  create_sqs_kms_key    = false
  create_nfw_kms_key    = false

  # Disable unnecessary buckets
  create_s3_elb_accesslogs_bucket = false
  create_s3_fedrampdoc_bucket     = false
  create_s3_installs_bucket       = false

  additional_kms_keys = [
    {
      name   = "controltower"
      policy = "${data.aws_iam_policy_document.controltower_kms.json}"
    }
  ]

  #FAUPDATE: This as an optional argument being added in case that the autoscaling role has already been created in an account (such as the testing lab). Default will always be true.
  create_autoscaling_role = false
}

data "aws_iam_policy_document" "controltower_kms" {

  statement {
    actions = ["kms:Decrypt", "kms:GenerateDataKey*"]
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
    resources = ["*"]
  }

  statement {
    actions = ["kms:Decrypt", "kms:GenerateDataKey*"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    resources = ["*"]
  }

}