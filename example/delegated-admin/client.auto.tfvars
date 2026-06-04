aws_region         = "us-gov-west-1"
default_aws_region = "us-gov-west-1"
resource_prefix    = "clientname-root"
is_gov             = true

# This is always set to true to create the cloudtrail S3 bucket using account setup PAK
create_cloudtrail = true

# Set both to FALSE on first apply, then run again with TRUE to apply the org cloudtrail and organization ID to policies
create_org_cloudtrail = false
is_organization       = false

# Uncomment on second run with ORG ID obtained from the output of the first run
#organization_id      = ""