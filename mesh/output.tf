# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
output "sg_a_to_b_id" {
  value = "${aws_security_group.sg_a_to_b.id}"
}
output "sg_a_to_c_id" {
  value = "${aws_security_group.sg_a_to_c.id}"
}
output "sg_b_to_c_id" {
  value = "${aws_security_group.sg_b_to_c.id}"
}
output "sg_b_to_a_id" {
  value = "${aws_security_group.sg_b_to_a.id}"
}
output "sg_c_to_a_id" {
  value = "${aws_security_group.sg_c_to_a.id}"
}
output "sg_c_to_b_id" {
  value = "${aws_security_group.sg_c_to_b.id}"
}
output "sg_a_to_b_s_id" {
  value = "${aws_security_group.sg_a_to_b_s.id}"
}
output "sg_a_to_c_s_id" {
  value = "${aws_security_group.sg_a_to_c_s.id}"
}
output "sg_b_to_c_s_id" {
  value = "${aws_security_group.sg_b_to_c_s.id}"
}
output "sg_b_to_a_s_id" {
  value = "${aws_security_group.sg_b_to_a_s.id}"
}
output "sg_c_to_a_s_id" {
  value = "${aws_security_group.sg_c_to_a_s.id}"
}
output "sg_c_to_b_s_id" {
  value = "${aws_security_group.sg_c_to_b_s.id}"
}