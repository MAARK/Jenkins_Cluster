terraform {
  backend "s3" {
    bucket = "jenkins-cluster-terraform-states"
    key    = "jenkins"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
