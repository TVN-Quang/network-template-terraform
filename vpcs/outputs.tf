output "azs_name" {
  value = data.aws_availability_zones.available.names
}

output "vpc" {
  value = module.vpc
}

# output "vpc_endpoints" {
#   value = local.endpoints
# }
