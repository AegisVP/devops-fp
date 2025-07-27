terraform {
  backend "s3" {
    bucket       = "vp-dja-terraform-state-bucket"
    key          = "terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }
}
