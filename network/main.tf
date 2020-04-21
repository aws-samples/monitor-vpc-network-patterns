# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

data "aws_availability_zones" "available" {}

resource "aws_vpc" "VPC" {
  cidr_block       = "${var.vpccidr}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "VPC"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags = {
    Name = "IGW"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_subnet" "SubnetPublicA" {
  vpc_id     = "${aws_vpc.VPC.id}"
  cidr_block = "${var.AppPublicCIDRA}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "SubnetPublicA"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.fgcluster}" = "shared"
  }
}
resource "aws_subnet" "SubnetPublicB" {
  vpc_id     = "${aws_vpc.VPC.id}"
  cidr_block = "${var.AppPublicCIDRB}"
  map_public_ip_on_launch = "true"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "SubnetPublicB"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.fgcluster}" = "shared"
  }
}
resource "aws_subnet" "SubnetPrivateA" {
  vpc_id     = "${aws_vpc.VPC.id}"
  cidr_block = "${var.AppPrivateCIDRA}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "SubnetPrivateA"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_subnet" "SubnetPrivateS" {
  vpc_id     = "${aws_vpc.VPC.id}"
  cidr_block = "${var.AppPrivateCIDRS}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "SubnetPrivateS"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
    "kubernetes.io/cluster/${var.fgcluster}" = "shared"
  }
}
resource "aws_subnet" "SubnetPrivateS2" {
  vpc_id     = "${aws_vpc.VPC.id}"
  cidr_block = "${var.AppPrivateCIDRS2}"
  map_public_ip_on_launch = "false"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "SubnetPrivateS2"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
    "kubernetes.io/cluster/${var.fgcluster}" = "shared"
  }
}

resource "aws_route_table" "RouteTablePublic" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags = {
    Name = "PublicRT"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_route" "public_route" {
  route_table_id            = "${aws_route_table.RouteTablePublic.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.IGW.id}"
  depends_on                = ["aws_route_table.RouteTablePublic"]
}
resource "aws_route_table" "RouteTablePrivateA" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags = {
    Name = "PrivateRTA"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_route" "private_route" {
  route_table_id            = "${aws_route_table.RouteTablePrivateA.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NatGatewayA.id}"
  depends_on                = ["aws_route_table.RouteTablePrivateA"]
}

resource "aws_route_table_association" "SubnetRouteTableAssociatePublicA" {
  subnet_id      = "${aws_subnet.SubnetPublicA.id}"
  route_table_id = "${aws_route_table.RouteTablePublic.id}"
}
resource "aws_route_table_association" "SubnetRouteTableAssociatePublicB" {
  subnet_id      = "${aws_subnet.SubnetPublicB.id}"
  route_table_id = "${aws_route_table.RouteTablePublic.id}"
}
resource "aws_route_table_association" "SubnetRouteTableAssociatePrivateA" {
  subnet_id      = "${aws_subnet.SubnetPrivateA.id}"
  route_table_id = "${aws_route_table.RouteTablePrivateA.id}"
}
resource "aws_route_table_association" "SubnetRouteTableAssociatePrivateS" {
  subnet_id      = "${aws_subnet.SubnetPrivateS.id}"
  route_table_id = "${aws_route_table.RouteTablePrivateA.id}"
}
resource "aws_route_table_association" "SubnetRouteTableAssociatePrivateS2" {
  subnet_id      = "${aws_subnet.SubnetPrivateS2.id}"
  route_table_id = "${aws_route_table.RouteTablePrivateA.id}"
}

resource "aws_nat_gateway" "NatGatewayA" {
  allocation_id = "${aws_eip.EIPNatGWA.id}"
  subnet_id     = "${aws_subnet.SubnetPublicA.id}"
  tags = {
    Name = "NatGWA"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_eip" "EIPNatGWA" {
  vpc      = true
  tags = {
    Name = "EIPNatGWA"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_flow_log" "flowlog" {
  log_destination      = "${aws_s3_bucket.flowlogBucket.arn}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = "${aws_vpc.VPC.id}"
  log_format = "$${version} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${account-id} $${type} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${pkt-srcaddr} $${pkt-dstaddr} $${protocol} $${bytes} $${packets} $${start} $${end} $${action} $${tcp-flags} $${log-status}"
  tags = {
    Name = "Flowlog"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_s3_bucket" "flowlogBucket" {
  bucket = "${var.BucketName}"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = {
    Name = "FlowlogBucket"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id = "${aws_vpc.VPC.id}"
  cidr_block       = "${var.vpccidr_extra}"
}
