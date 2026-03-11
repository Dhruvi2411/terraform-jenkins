terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-11-03-26"
    key          = "terraform/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
