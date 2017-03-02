variable "region" {
    description = "Region of the VPC, eg. eu-central-1"
}


variable "cidr_block" {
    description = "CIDR block for a vpc, eg. 10.100.0.0/16"
    default = "10.100.0.0/16"
}

variable "cidr_prefix" {
    description = "That depends on your netmask, eg. 10.100"
    default = "10.100"
}

variable "subnets_netmask" {
    description = "Netmask of all created subnets, eg. 24"
    default = "24"
}

variable "name" {
    description = ""
}

variable "map_public_ip_on_launch" {
    description = "Map public ip on EC2 instance launch"
    default = false
}

variable "availability_zones" {
    description = "Available zones in format [a, b, c]"
    type = "list"
    default = ["a", "b"]
}
