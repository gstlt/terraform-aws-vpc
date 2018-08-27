variable "region" {
  description = "Region of the VPC, eg. eu-central-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for a vpc, eg. 10.100.0.0/16"
}

variable "public_subnets_cidr_block" {
  description = "CIDR block for public subnets"
  type        = "list"
}

variable "private_subnets_cidr_block" {
  description = "CIDR block for private subnets"
  type        = "list"
}

variable "name" {
  description = "Name used in tagging of resources"
  type        = "string"
  default     = ""
}

variable "map_public_ip_on_launch" {
  description = "Map public ip on EC2 instance launch"
  default     = false
}

variable "azs_mapping" {
  description = "Mapping of region to availability zones"
  type        = "map"

  # Last update: August 27 2018
  default = {
    # US, North Virginia
    us-east-1 = "a,b,c,d,e,f"

    # US, Ohio
    us-east-2 = "a,b,c"

    # US, North California
    us-west-1 = "a,b" # Two zones for new customers, there are three in total

    # US, Oregon
    us-west-2 = "a,b,c"

    # Mumbai
    ap-south-1 = "a,b"

    # South Korea, Seoul (no B zone?)
    ap-northeast-2 = "a,c"

    # Singapore
    ap-southeast-1 = "a,b,c"

    # AU, Sydney
    ap-southeast-2 = "a,b,c"

    # Tokyo
    ap-northeast-1 = "a,c,d"

    # Canada
    ca-central-1 = "a,b"

    # DE, Frankfurt
    eu-central-1 = "a,b,c"

    # Ireland
    eu-west-1 = "a,b,c"

    # UK, London
    eu-west-2 = "a,b,c"

    # FR, Paris
    eu-west-3 = "a,b,c"

    # São Paulo
    sa-east-1 = "a,c" # Two zones for new customers, there are three in total
  }
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  default     = true
}
