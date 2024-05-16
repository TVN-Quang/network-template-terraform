include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../vpc-endpoints"
}

dependency "vpcs" {
  config_path = "../vpc"
}

inputs = {
    vpc = dependency.vpcs.outputs.vpc

    vpc_endpoints = {
        network-vpc = {
            endpoints = {
                dynamodb = {
                    service         = "dynamodb"
                    service_type    = "Gateway"
                    route_table_ids = []
                    tags            = { Name = "dynamodb-vpc-endpoint" }
                },
                s3 = {
                    service         = "s3"
                    service_type    = "Gateway"
                    route_table_ids = []
                    tags            = { Name = "s3-vpc-endpoint" }
                },
            }
        }
    }
}