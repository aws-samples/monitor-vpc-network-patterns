# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
resource "aws_ec2_transit_gateway" "tgw" {
  count = var.use_tgw ? 1 : 0
  description = "TGW"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support = "enable"
  tags = {
    Name = "TGW"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_a" {
  count = var.use_tgw ? 1 : 0
  subnet_ids         = ["${var.subnet_a}","${var.subnet_a2}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
  vpc_id             = "${var.vpc_a}"
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_b" {
  count = var.use_tgw ? 1 : 0
  subnet_ids         = ["${var.subnet_b}","${var.subnet_b2}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
  vpc_id             = "${var.vpc_b}"
}
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_c" {
  count = var.use_tgw ? 1 : 0
  subnet_ids         = ["${var.subnet_c}","${var.subnet_c2}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
  vpc_id             = "${var.vpc_c}"
}
resource "aws_route" "tgw_rt_a_to_b" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_a}"
  destination_cidr_block    = "${var.cidr_b}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_a_to_b_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_a_s}"
  destination_cidr_block    = "${var.cidr_b_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_a_to_c" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_a}"
  destination_cidr_block    = "${var.cidr_c}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_a_to_c_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_a_s}"
  destination_cidr_block    = "${var.cidr_c_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_b_to_c" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_b}"
  destination_cidr_block    = "${var.cidr_c}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_b_to_c_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_b_s}"
  destination_cidr_block    = "${var.cidr_c_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_b_to_a" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_b}"
  destination_cidr_block    = "${var.cidr_a}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_b_to_a_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_b_s}"
  destination_cidr_block    = "${var.cidr_a_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_c_to_b" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_c}"
  destination_cidr_block    = "${var.cidr_b}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_c_to_b_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_c_s}"
  destination_cidr_block    = "${var.cidr_b_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_c_to_a" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_c}"
  destination_cidr_block    = "${var.cidr_a}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}
resource "aws_route" "tgw_rt_c_to_a_s" {
  count = var.use_tgw ? 1 : 0
  route_table_id            = "${var.rt_c_s}"
  destination_cidr_block    = "${var.cidr_a_s}"
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw[0].id}"
}


resource "aws_vpc_peering_connection" "a_to_b" {
  count = var.use_tgw ? 0 : 1
  peer_vpc_id   = "${var.vpc_b}"
  vpc_id        = "${var.vpc_a}"
  auto_accept   = true

  tags = {
    Name = "VPC Peering between A and B"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
resource "aws_vpc_peering_connection" "a_to_c" {
  count = var.use_tgw ? 0 : 1
  peer_vpc_id   = "${var.vpc_c}"
  vpc_id        = "${var.vpc_a}"
  auto_accept   = true

  tags = {
    Name = "VPC Peering between A and C"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
resource "aws_vpc_peering_connection" "b_to_c" {
  count = var.use_tgw ? 0 : 1
  peer_vpc_id   = "${var.vpc_c}"
  vpc_id        = "${var.vpc_b}"
  auto_accept   = true

  tags = {
    Name = "VPC Peering between C and B"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "r_a_to_b" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_a}"
  destination_cidr_block    = "${var.cidr_b}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.a_to_b[0].id}"
}
resource "aws_route" "r_a_to_c" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_a}"
  destination_cidr_block    = "${var.cidr_c}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.a_to_c[0].id}"
}
resource "aws_route" "r_b_to_a" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_b}"
  destination_cidr_block    = "${var.cidr_a}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.a_to_b[0].id}"
}
resource "aws_route" "r_c_to_a" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_c}"
  destination_cidr_block    = "${var.cidr_a}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.a_to_c[0].id}"
}
resource "aws_route" "r_b_to_c" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_b}"
  destination_cidr_block    = "${var.cidr_c}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.b_to_c[0].id}"
}
resource "aws_route" "r_c_to_b" {
  count = var.use_tgw ? 0 : 1
  route_table_id            = "${var.rt_c}"
  destination_cidr_block    = "${var.cidr_b}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.b_to_c[0].id}"
}


resource "aws_security_group" "sg_a_to_b" {
  name_prefix        = "sg_a_to_b"
  description = "Allow inbound traffic to VPC B from VPC A"
  vpc_id      = "${var.vpc_b}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_a}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_a_to_b"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_a_to_b_s" {
  name_prefix        = "sg_a_to_b_s"
  description = "Allow inbound traffic to VPC B from VPC A over secondary CIDR"
  vpc_id      = "${var.vpc_b}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_a_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_a_to_b_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_security_group" "sg_a_to_c" {
  name_prefix        = "sg_a_to_c"
  description = "Allow inbound traffic to VPC C from VPC A"
  vpc_id      = "${var.vpc_c}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_a}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_a_to_c"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_a_to_c_s" {
  name_prefix        = "sg_a_to_c_s"
  description = "Allow inbound traffic to VPC C from VPC A over secondary CIDR"
  vpc_id      = "${var.vpc_c}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_a_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_a_to_c_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_security_group" "sg_c_to_a" {
  name_prefix        = "sg_c_to_a"
  description = "Allow inbound traffic to VPC A from VPC C"
  vpc_id      = "${var.vpc_a}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_c}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_c_to_a"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_c_to_a_s" {
  name_prefix        = "sg_c_to_a_s"
  description = "Allow inbound traffic to VPC A from VPC C over secondary CIDR"
  vpc_id      = "${var.vpc_a}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_c_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_c_to_a_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_security_group" "sg_b_to_a" {
  name_prefix        = "sg_b_to_a"
  description = "Allow inbound traffic to VPC A from VPC B"
  vpc_id      = "${var.vpc_a}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_b}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_b_to_a"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_b_to_a_s" {
  name_prefix        = "sg_b_to_a_s"
  description = "Allow inbound traffic to VPC A from VPC B over secondary CIDR"
  vpc_id      = "${var.vpc_a}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_b_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_b_to_a_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_security_group" "sg_b_to_c" {
  name_prefix        = "sg_b_to_c"
  description = "Allow inbound traffic to VPC C from VPC B"
  vpc_id      = "${var.vpc_c}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_b}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_b_to_c"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_b_to_c_s" {
  name_prefix        = "sg_b_to_c_s"
  description = "Allow inbound traffic to VPC C from VPC B over secondary CIDR"
  vpc_id      = "${var.vpc_c}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_b_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_b_to_c_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_security_group" "sg_c_to_b" {
  name_prefix        = "sg_c_to_b"
  description = "Allow inbound traffic to VPC B from VPC C"
  vpc_id      = "${var.vpc_b}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_c}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_c_to_b"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_security_group" "sg_c_to_b_s" {
  name_prefix        = "sg_c_to_b_s"
  description = "Allow inbound traffic to VPC B from VPC C over secondary CIDR"
  vpc_id      = "${var.vpc_b}"

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks     = ["${var.cidr_c_s}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_c_to_b_s"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}