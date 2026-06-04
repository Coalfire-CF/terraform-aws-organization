provider "aws" {
  region                 = var.aws_region
  skip_region_validation = true
  use_fips_endpoint      = true
  alias                  = "root"

  assume_role {
    role_arn = "arn:${local.partition}:iam::${local.root_account_id}:role/OrganizationAccountAccessRole"
  }

  default_tags {
    tags = {
      "FedRAMP"   = "True"
      "Terraform" = "True"
    }
  }
}

provider "aws" {
  region            = var.aws_region
  use_fips_endpoint = true
}