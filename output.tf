# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

output "VpcA" {
  value = "${module.vpcA.VpcId}"
}
output "VpcB" {
  value = "${module.vpcB.VpcId}"
}
output "VpcC" {
  value = "${module.vpcC.VpcId}"
}
output "EmailTopic" {
  value = "${module.alerts.EmailTopic}"
}
