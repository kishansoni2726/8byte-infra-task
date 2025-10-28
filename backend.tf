terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket       = "terraform-aws-8bytes-demo"
    key          = "terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}