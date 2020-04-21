# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
output "EmailTopic" {
  value = "${aws_sns_topic.route_table_alarms.id}"
}