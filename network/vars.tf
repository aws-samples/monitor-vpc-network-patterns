# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

variable "vpccidr" {
  default = "10.20.0.0/16"
}
variable "vpccidr_extra" { }
variable "ProjectTag" {
}
variable "BucketName" {
}
variable "AppPublicCIDRB" {}
variable "AppPublicCIDRA" {
  default = "10.20.1.0/24"
}
variable "AppPrivateCIDRA" {
  default = "10.20.4.0/24"
}
variable "AppPrivateCIDRS" { }
variable "AppPrivateCIDRS2" { }
variable "Environment" {
}
variable "fgcluster" {}