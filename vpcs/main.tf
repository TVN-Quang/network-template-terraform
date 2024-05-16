locals {
  region = "ap-southeast-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Project = "Lab"
    Owner   = "quangtvn1"
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./terraform-aws-vpc"
  for_each = {
    for index, vpc in var.vpcs : vpc.name => vpc
  }
  name = each.value.name
  cidr = each.value.cidr

  azs = local.azs

  private_subnets  = each.value.private_subnets
  public_subnets   = each.value.public_subnets
  database_subnets = each.value.database_subnets

  private_subnet_names = try(each.value.private_subnet_names, null)
  # public_subnet_names omitted to show default name generation for all three subnets
  database_subnet_names = try(each.value.database_subnet_names, null)
  public_subnet_names   = try(each.value.public_subnet_names, null)

  create_database_subnet_route_table = each.value.create_database_subnet_route_table
  enable_nat_gateway                 = each.value.enable_nat_gateway
  single_nat_gateway                 = each.value.single_nat_gateway
  one_nat_gateway_per_az             = each.value.one_nat_gateway_per_az

  tags = local.tags
}

# locals {
#   endpoints = [for e in var.vpc_endpoints : {
#     value = e
#   }]
# }

module "vpc_endpoints" {
  source   = "../vpc-endpoints/vpc-endpoint"
  for_each = var.vpc_endpoints

  vpc_id = module.vpc[each.key].vpc_id

  create_security_group      = true
  security_group_name_prefix = "vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc[each.key].vpc_cidr_block]
    }
  }

  endpoints = each.value.endpoints

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })
}
