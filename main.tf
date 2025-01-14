terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "replace me"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "prasheel-test-bucket" {
  bucket_prefix = "my-tf-bucket-cloudfixlinter"
  tags = {
    Owner     = "prasheel.tiwari@trilogy.com"
    yor_trace = "1bf819f5-d130-4f67-810e-d6e24e32e125"
  }
}

resource "aws_ebs_volume" "data-vol" {
  availability_zone = "us-east-1a"
  size              = 1
  type              = "gp2"
  tags = {
    Owner     = "prasheel.tiwari@trilogy.com"
    yor_trace = "2e9ace76-9d14-4a56-8cf4-0a90393b5de6"
  }
}