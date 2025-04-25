data "terraform_remote_state" "primary" {
  backend = "s3"
  config = {
    bucket = "pilot-light-dr-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}


terraform {
  backend "s3" {
    bucket       = "pilotlight-disasterrecovery-bucket"
    key          = "terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}