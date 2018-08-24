output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "public_subnets" {
    value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
    value = ["${aws_subnet.private.*.id}"]
}

output "public_route_table" {
  value = "${aws_route_table.public.*.id}"
}

output "private_route_tables" {
  value = ["${aws_route_table.private.*.id}"]
}

output "nat_gateway_public_ips" {
  value = ["${aws_eip.nat_gateways.*.public_ip}"]
}