terraform {
  backend "s3" {
    bucket       = "pilot-light-dr-bucket"
    key          = "terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}