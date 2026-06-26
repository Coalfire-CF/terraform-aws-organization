# Run on local for first deploy
terraform {
  backend "local" {}
}

# Comment out above and migrate state on second deploy
# terraform {
#   backend "s3" {
#     bucket       = "client-root-us-gov-west-1-tf-state"
#     region       = "us-gov-west-1"
#     key          = "client-root/us-gov-west-1/org-setup.tfstate"
#     encrypt      = true
#     use_lockfile = true
#   }
# }