terraform {
  backend "remote" {
    organization = "example-org-ca4fae"
    workspaces {
      name = "org"
    }
  }

}
provider "aws" {
  region     = var.region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}