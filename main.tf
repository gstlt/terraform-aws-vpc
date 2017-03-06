resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"

    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support = "${var.enable_dns_support}"

    tags {
        Name = "${var.name} VPC"
    }
}

# Generate subnets according to number of AZs defined in variable
resource "aws_subnet" "public" {
    count = "${length( split(",", lookup(var.azs_mapping, var.region) ) )}"

    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_prefix}.${count.index}.0/${var.subnets_netmask}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

    availability_zone = "${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"

    tags {
        Name = "${var.name} ${var.region}${element(split(",", lookup(var.azs_mapping, var.region)), count.index)}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.main.id}"

    lifecycle {
      create_before_destroy = true
    }

    tags {
        Name = "${var.name} internet gateway"
    }
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.main.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"

    lifecycle {
      create_before_destroy = true
    }
}
