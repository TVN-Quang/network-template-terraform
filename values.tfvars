vpcs = [
  #   {

  #     name = "workload-vpc"

  #     cidr         = "10.0.0.0/16"
  #     private_subnets  = ["10.0.0.0/24", "10.0.2.0/24"]
  #     database_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  #     public_subnets   = ["10.0.6.0/24", "10.0.7.0/24"]

  #     private_subnet_names = ["workload-eks-subnet-1a", "workload-eks-subnet-1b"]
  #     public_subnet_names  = ["public-subnet-1a", "public-subnet-1b"]

  #     create_database_subnet_route_table = true

  #     enable_nat_gateway     = false
  #     single_nat_gateway     = false
  #     one_nat_gateway_per_az = false
  #   },
  {
    name = "network-vpc"

    cidr             = "10.1.0.0/16"
    private_subnets  = ["10.1.0.0/24", "10.1.2.0/24"]
    database_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
    public_subnets   = ["10.1.6.0/24", "10.1.7.0/24"]

    private_subnet_names = ["network-eks-subnet-1a", "network-eks-subnet-1b"]
    public_subnet_names  = ["public-subnet-1a", "public-subnet-1b"]

    create_database_subnet_route_table = true

    enable_nat_gateway     = false
    single_nat_gateway     = false
    one_nat_gateway_per_az = false
  }
]

vpc_endpoints = {
  network-vpc = {
    endpoints = {
      dynamodb = {
        service          = "dynamodb"
        service_type     = "Gateway"
        route_table_name = ["*network-eks-subnet-1a"]
        # route_table_ids  = []
        tags             = { Name = "dynamodb-vpc-endpoint" }
      },
      s3 = {
        service          = "s3"
        service_type     = "Gateway"
        route_table_name = ["*network-eks-subnet-*"]
        # route_table_ids  = []
        tags             = { Name = "s3-vpc-endpoint" }
      },
    }
  }
}

