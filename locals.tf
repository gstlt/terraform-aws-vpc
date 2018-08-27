locals {
  number_of_azs             = "${length( split(",", lookup(var.azs_mapping, var.region) ) )}"
  number_of_private_subnets = "${length(var.private_subnets_cidr_block)}"
  number_of_public_subnets  = "${length(var.public_subnets_cidr_block)}"
}
