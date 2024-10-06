locals {
  region = "ap-south-1"
  name = "${terraform.workspace}-cluster"
  vpc_cidr = "172.31.0/20"
  azs      = ["ap-south-1a", "ap-south-1b"]
  public_subnets = ["172.31.1.0/24", "172.31.2.0/24"]
  private_subnet = ["172.31.3.0", "172.31.4.0/24"]
  intra_subnets  = ["172.31.5.0", "172.31.6.0/24"]
  tags = {
    Example = local.name
  }
}

provider "aws" {
  region = "ap-south-1"
}
