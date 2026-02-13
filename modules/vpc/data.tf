# This tells Terraform: "Go find out which region we are in and call it 'current'"
data "aws_region" "current" {}

# You likely already have this, but make sure it's in the module too:
data "aws_availability_zones" "AZs" {
  state = "available"
}