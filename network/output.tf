# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

output "VpcId" {
  value = "${aws_vpc.VPC.id}"
}
output "SubnetIdPublicA" {
  value = "${aws_subnet.SubnetPublicA.id}"
}
output "SubnetIdPublicB" {
  value = "${aws_subnet.SubnetPublicB.id}"
}
output "SubnetIdPrivateA" {
  value = "${aws_subnet.SubnetPrivateA.id}"
}
output "RouteTablePrivate" {
  value = "${aws_route_table.RouteTablePrivateA.id}"
}
output "RouteTablePrivateS" {
  value = "${aws_route_table.RouteTablePublic.id}"
}
