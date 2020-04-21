# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

provider "aws" {
  region     = "${var.region}"
}

module "vpcA" {
  source = "./network"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcA"
  vpccidr = "${var.vpccidrA}"
  vpccidr_extra = "${var.vpccidrA_extra}"
  AppPublicCIDRA = "${var.AppPublicCIDRA}"
  AppPublicCIDRB = "${var.AppPublicCIDRA2}"
  AppPrivateCIDRA = "${var.AppPrivateCIDRA}"
  AppPrivateCIDRS = "${var.AppPrivateCIDRSA}"
  AppPrivateCIDRS2 = "${var.AppPrivateCIDRS2A}"
  BucketName = "${var.BucketNameA}"
  fgcluster = "${var.fgcluster}"
}
module "vpcB" {
  source = "./network"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcB"
  vpccidr = "${var.vpccidrB}"
  vpccidr_extra = "${var.vpccidrB_extra}"
  AppPublicCIDRA = "${var.AppPublicCIDRB}"
  AppPublicCIDRB = "${var.AppPublicCIDRB2}"
  AppPrivateCIDRA = "${var.AppPrivateCIDRB}"
  AppPrivateCIDRS = "${var.AppPrivateCIDRSB}"
  AppPrivateCIDRS2 = "${var.AppPrivateCIDRS2B}"
  BucketName = "${var.BucketNameB}"
  fgcluster = "${var.fgcluster}"
}
module "vpcC" {
  source = "./network"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcC"
  vpccidr = "${var.vpccidrC}"
  vpccidr_extra = "${var.vpccidrC_extra}"
  AppPublicCIDRA = "${var.AppPublicCIDRC}"
  AppPublicCIDRB = "${var.AppPublicCIDRC2}"
  AppPrivateCIDRA = "${var.AppPrivateCIDRC}"
  AppPrivateCIDRS = "${var.AppPrivateCIDRSC}"
  AppPrivateCIDRS2 = "${var.AppPrivateCIDRS2C}"
  BucketName = "${var.BucketNameC}"
  fgcluster = "${var.fgcluster}"
}
module "alerts" {
  source = "./alerts"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "${var.Environment}"
}
module "mesh" {
  source = "./mesh"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "${var.Environment}"
  cidr_a = "${var.vpccidrA}"
  cidr_b = "${var.vpccidrB}"
  cidr_c = "${var.vpccidrC}"
  vpc_a = "${module.vpcA.VpcId}"
  vpc_b = "${module.vpcB.VpcId}"
  vpc_c = "${module.vpcC.VpcId}"
  subnet_a = "${module.vpcA.SubnetIdPublicA}"
  subnet_b = "${module.vpcB.SubnetIdPublicA}"
  subnet_c = "${module.vpcC.SubnetIdPublicA}"
  subnet_a2 = "${module.vpcA.SubnetIdPublicB}"
  subnet_b2 = "${module.vpcB.SubnetIdPublicB}"
  subnet_c2 = "${module.vpcC.SubnetIdPublicB}"
  rt_a = "${module.vpcA.RouteTablePrivate}"
  rt_b = "${module.vpcB.RouteTablePrivate}"
  rt_c = "${module.vpcC.RouteTablePrivate}"
  rt_a_s = "${module.vpcA.RouteTablePrivateS}"
  rt_b_s = "${module.vpcB.RouteTablePrivateS}"
  rt_c_s = "${module.vpcC.RouteTablePrivateS}"
  cidr_a_s = "${var.vpccidrA_extra}"
  cidr_b_s = "${var.vpccidrB_extra}"
  cidr_c_s = "${var.vpccidrC_extra}"
  use_tgw = "${var.use_tgw}"
}
module "generators_a" {
  source = "./generators"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcA"
  ami = "${lookup(var.amis, var.region)}"
  sg = ["${module.mesh.sg_b_to_a_id}","${module.mesh.sg_c_to_a_id}","${module.mesh.sg_b_to_a_s_id}","${module.mesh.sg_c_to_a_s_id}"]
  subnet = "${module.vpcA.SubnetIdPrivateA}" 
  region = "${var.region}"
}
module "generators_b" {
  source = "./generators"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcB"
  ami = "${lookup(var.amis, var.region)}"
  sg = ["${module.mesh.sg_a_to_b_id}","${module.mesh.sg_c_to_b_id}","${module.mesh.sg_a_to_b_s_id}","${module.mesh.sg_c_to_b_s_id}"]
  subnet = "${module.vpcB.SubnetIdPrivateA}" 
  region = "${var.region}"
}
module "generators_c" {
  source = "./generators"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "VpcC"
  ami = "${lookup(var.amis, var.region)}"
  sg = ["${module.mesh.sg_a_to_c_id}","${module.mesh.sg_b_to_c_id}","${module.mesh.sg_a_to_c_s_id}","${module.mesh.sg_b_to_c_s_id}"]
  subnet = "${module.vpcC.SubnetIdPrivateA}" 
  region = "${var.region}"
}
module "reports" {
  source = "./reports"

  ProjectTag =  "${var.ProjectTag}"
  Environment =  "${var.Environment}"
  region = "${var.region}"
  BucketA = "${var.BucketNameA}"
  BucketB = "${var.BucketNameB}"
  BucketC = "${var.BucketNameC}"
}