terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-bucket-2001"
    region = "ap-southeast-2"
    encrypt = true
    use_lockfile = true
  }


}

provider "aws" {
  region = "ap-southeast-2"
}