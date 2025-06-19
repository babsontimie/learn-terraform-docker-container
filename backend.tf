terraform {
  backend "s3" {
    bucket         = "tee-terraform-state-bucket"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

