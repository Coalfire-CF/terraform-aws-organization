locals {
  partition = var.is_gov ? "aws-us-gov" : "aws"
  azs       = ["${var.aws_region}a", "${var.aws_region}b"]

  root_account_id    = "" # Root Account ID
  mgmt_account_id    = "" # Management Plane Account ID
  network_account_id = "" # Network Account ID
  prod_account_id    = "" # Production Account ID
  stage_account_id   = "" # Staging Account ID

  share_accounts = [
    local.root_account_id, local.mgmt_account_id, local.network_account_id, local.prod_account_id, local.stage_account_id
  ]
}