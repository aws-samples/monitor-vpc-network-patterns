# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

variable "region" {
  default = "us-west-2"
}
variable "ProjectTag" {
  default = "TGWMonitor"
}
variable "Environment" {
  default = "Test"
}
variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-0080e4c5bc078760e"
    "us-east-2" = "ami-0e01ce4ee18447327"
    "us-west-2" = "ami-01e24be29428c15b2"
  }
}
variable "vpccidrA" {
  default = "10.0.0.0/16"
}
variable "vpccidrB" {
  default = "10.1.0.0/16"
}
variable "vpccidrC" {
  default = "10.2.0.0/16"
}
variable "AppPublicCIDRA" {
  default = "10.0.0.0/24"
}
variable "AppPublicCIDRA2" {
  default = "10.0.4.0/24"
}
variable "AppPrivateCIDRA" {
  default = "10.0.1.0/24"
}
variable "AppPublicCIDRB" {
  default = "10.1.0.0/24"
}
variable "AppPublicCIDRB2" {
  default = "10.1.4.0/24"
}
variable "AppPrivateCIDRB" {
  default = "10.1.1.0/24"
}
variable "AppPublicCIDRC" {
  default = "10.2.0.0/24"
}
variable "AppPublicCIDRC2" {
  default = "10.2.4.0/24"
}
variable "AppPrivateCIDRC" {
  default = "10.2.1.0/24"
}
variable "BucketNameA" {}
variable "BucketNameB" {}
variable "BucketNameC" {}
variable "use_tgw" {
  description = "If true, set up Transit Gateway.  Otherwise use VPC peering."
  type        = bool
}
variable "vpccidrA_extra" {
  default = "3.0.0.0/16"
}
variable "vpccidrB_extra" {
  default = "3.1.0.0/16"
}
variable "vpccidrC_extra" {
  default = "3.2.0.0/16"
}
variable "AppPrivateCIDRSA" {
  default = "3.0.1.0/24"
}
variable "AppPrivateCIDRSB" {
  default = "3.1.1.0/24"
}
variable "AppPrivateCIDRSC" {
  default = "3.2.1.0/24"
}
variable "AppPrivateCIDRS2A" {
  default = "3.0.2.0/24"
}
variable "AppPrivateCIDRS2B" {
  default = "3.1.2.0/24"
}
variable "AppPrivateCIDRS2C" {
  default = "3.2.2.0/24"
}
variable fgcluster {
  default = "fgnat"
}