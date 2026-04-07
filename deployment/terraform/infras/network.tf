module "vpc-misp" {
  source = "sudo-terraform-aws-modules/sudo-vpc/aws"
  
  name = "misp-workbench"

  cidr = "10.0.0.0/16"

  azs = ["ap-southeast-2a", "ap-southeast-2b"]

  private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets =  ["10.0.2.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true

}