terraform {
  required_version = ">= 0.10.3" # support for Local Values
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.name} VPC"
  }
}

## Subnets

# Generate subnets according to number of AZs defined in variable
resource "aws_subnet" "public" {
  count = "${local.number_of_public_subnets}"

  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnets_cidr_block[count.index]}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  availability_zone = "${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"

  tags {
    Name = "${var.name} public ${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"
  }
}

resource "aws_subnet" "private" {
  count = "${local.number_of_private_subnets}"

  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_subnets_cidr_block[count.index]}"
  map_public_ip_on_launch = false

  availability_zone = "${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"

  tags {
    Name = "${var.name} private ${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"
  }
}

## Internet gateway for public subnets
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.main.id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.name} internet gateway"
  }
}

## Public subnets route tables and associations
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"

  timeouts {
    create = "5m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  count = "${local.number_of_public_subnets}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat_gateways" {
  count = "${local.number_of_public_subnets}"

  vpc = true

  tags {
    Name = "${var.name} NAT gateway EIP"
  }
}

## Private subnets - NAT gateways (those live in public subnets)
resource "aws_nat_gateway" "main" {
  count = "${local.number_of_public_subnets}"

  allocation_id = "${element(aws_eip.nat_gateways.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.name} NAT gateway"
  }

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_route_table" "private" {
  count = "${local.number_of_private_subnets}"

  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "private_nat_gateway" {
  count = "${local.number_of_private_subnets}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = "${local.number_of_private_subnets}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
