provider "aws" {
}

terraform {
  backend "s3" {
    bucket = "tfstate-lab-application"
    key    = "terraform-2.tfstate"
    region = "us-east-1"
  }
}
