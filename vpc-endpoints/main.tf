locals {
  region = "ap-southeast-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Project = "Lab"
    Owner   = "quangtvn1"
  }
}

data "aws_availability_zones" "available" {}

module "vpc_endpoints" {
  source   = "./vpc-endpoint"
  for_each = var.vpc_endpoints

  vpc_id = var.vpc[each.key].vpc_id

  create_security_group      = true
  security_group_name_prefix = "vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [var.vpc[each.key].vpc_cidr_block]
    }
  }

  endpoints = each.value.endpoints

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })
}