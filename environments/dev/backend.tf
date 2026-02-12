terraform {
  backend "s3" {
    bucket = "my1stbucketforterraform"
    key = "dev/infra/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform"
    encrypt = true
  }
}