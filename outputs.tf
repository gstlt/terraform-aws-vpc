output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "subnets" {
    value = ["${aws_subnet.public.*.id}"]
}

# output "private_cidr" {
#     value = "${var.cidr_block}"
# }
