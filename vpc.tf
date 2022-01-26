
# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
  enable_dns_hostnames = true
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
}
