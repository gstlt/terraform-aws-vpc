# terraform-aws-vpc

Terraform module for managing VPCs

## Usage

```
module "main_vpc" {
  source = "modules/vpc"

  name   = "Main"
  region = "eu-cental-1"

  vpc_cidr_block = "10.100.0.0/16"

  public_subnets_cidr_block  = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"]
  private_subnets_cidr_block = ["10.100.10.0/24", "10.100.11.0/24", "10.100.12.0/24"]

  # map public IPs on launch in public subnets
  map_public_ip_on_launch = true
}

```

We're also checking `azs_mapping` and name resources with proper zone:

```
variable "azs_mapping" {
    description = "Mapping of region to availability zones"
    type = "map"

    default = {
        # US, North Virginia
        us-east-1      = "a,b,c,d,e"
    }
}
```

## Creates

* VPC
* Subnets - the more you define, the more you'll get. If you specify 6 subnets in a zone with 2 availiability zones, you'll get 3 subnets in zone a and 3 in zone b
* Internet gateway
* Route table for public subnets
* NAT gateways, one per private subnet
* Route tables for private subnets (one for each)

## Outputs

* vpc_id - ID of created VPC
* public_subnets - list of public subnets IDs
* private_subnets - list of private subnets IDs
* public_route_table - public route table ID
* private_route_tables - private route tables IDs
* nat_gateway_public_ips - public IPs of NAT gateways

# Author

* [Grzegorz Adamowicz](https://github.com/gstlt)

# Contributors

# License

MIT license, see `LICENSE` file for details

