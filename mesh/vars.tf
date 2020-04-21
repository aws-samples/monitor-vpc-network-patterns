# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
variable "use_tgw" {
  description = "If true, set up Transit Gateway.  Otherwise use VPC peering."
  type        = bool
}
variable "vpc_a" {}
variable "vpc_b" {}
variable "vpc_c" {}
variable "subnet_a" {}
variable "subnet_b" {}
variable "subnet_c" {}
variable "subnet_a2" {}
variable "subnet_b2" {}
variable "subnet_c2" {}
variable "rt_a" {}
variable "rt_b" {}
variable "rt_c" {}
variable "rt_a_s" {}
variable "rt_b_s" {}
variable "rt_c_s" {}
variable "cidr_a" {}
variable "cidr_b" {}
variable "cidr_c" {}
variable "cidr_a_s" {}
variable "cidr_b_s" {}
variable "cidr_c_s" {}
variable "ProjectTag" {}
variable "Environment" {}