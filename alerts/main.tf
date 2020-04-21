# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
resource "aws_cloudwatch_event_rule" "route_table_event_rule" {
  name_prefix        = "RouteTableEventRule"
  description = "Capture changes to Route Tables"
  tags = {
    Name = "RTEventRule"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "CreateRoute",
      "DeleteRoute",
      "ReplaceRoute"
    ]
  }
}
PATTERN
}

resource "aws_lambda_function" "alarm_fn" {
  filename         = "alerts/alarm.zip"
  function_name    = "${var.ProjectTag}_${var.Environment}_alarm_fn"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "alarm.handler"
  source_code_hash = "${filebase64sha256("alerts/alarm.zip")}"
  runtime          = "python3.7"
  memory_size = "512"
  timeout = "30"

  environment {
    variables = {
      TOPIC_ARN = "${aws_sns_topic.route_table_alarms.arn}"
    }
  }

  tags = {
    Name = "alarm_fn"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }

}

resource "aws_iam_role" "lambda_role" {
  name_prefix = "lambda_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": ["lambda.amazonaws.com"]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags = {
    Name = "lambda_role_alerts"
    Project = "${var.ProjectTag}"
  }
}

resource "aws_iam_role_policy" "lambda_sqs_access" {
  name_prefix = "lambda_sqs_access"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sns:Publish"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_sns_topic.route_table_alarms.arn}"
      ]
    },
    {
      "Action": [
        "ec2:DescribeRouteTables",
        "ec2:DescribeVpcs"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-basicpolicy-attach" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "cw_call_lambda" {
  statement_id  = "cw_call_lambda"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.alarm_fn.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.route_table_event_rule.arn}"
}

resource "aws_cloudwatch_event_target" "route_table_lambda_tgt" {
  rule      = "${aws_cloudwatch_event_rule.route_table_event_rule.name}"
  arn       = "${aws_lambda_function.alarm_fn.arn}"
}

resource "aws_sns_topic" "route_table_alarms" {
  name_prefix = "RouteTableAlarms"
  display_name = "RouteTableAlarms"
  tags = {
    Name = "RTEventAlarmTopic"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}