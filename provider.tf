terraform {
  backend "remote" {
    organization = "example-org-ca4fae"
    workspaces {
      name = "xapo"
    }
  }

}
provider "aws" {
  region = var.region
}