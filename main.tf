terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


data "aws_secretsmanager_secret_version" "credential" {
  secret_id = ""
}
locals {
    cred = jsondecode(data.aws_secretsmanager_secret_version.credential.secret_string)
  
}


resource "aws_db_instance" "example" {
 identifier_prefix = "terraform-up-and-running"
 engine = "mysql"
 allocated_storage = 10
 instance_class = "db.t2.micro"
 skip_final_snapshot = true
 db_name = var.db_name
 # Pass the secrets to the resource
 username = local.cred.username
 password = local.cred.password
}