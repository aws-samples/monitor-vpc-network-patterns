# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
yum update -y
yum install -y httpd.x86_64
yum install -y curl
yum install -y jq
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
echo "#!/bin/bash" > /home/ec2-user/script.sh
echo "for F in \`aws ssm get-parameters-by-path --path '/Generator' --recursive --region ${var.region} | jq -r '.Parameters[].Value'\`; do curl \$F; done" >> /home/ec2-user/script.sh
chown ec2-user /home/ec2-user/script.sh
chmod +x /home/ec2-user/script.sh
echo "* * * * * ec2-user /bin/bash /home/ec2-user/script.sh" > /etc/cron.d/curl_all
chmod 0644 /etc/cron.d/curl_all
EOF
  }

}

resource "aws_instance" "generator" {
  count = "${var.num_workers}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = var.sg
  subnet_id = "${var.subnet}"
  associate_public_ip_address = false
  user_data_base64 = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.ssm_profile.name}"

  tags = {
    Name = "worker-${count.index}"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_ssm_parameter" "private-ip-ssm" {
  count = "${var.num_workers}"
  name  = "/Generator/${var.Environment}/privateip/${count.index}"
  type  = "String"
  value = "${element(aws_instance.generator.*.private_ip, count.index)}"
  overwrite = "true"
  tags = {
    Name = "ssm-privateip-generator-${count.index}"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name_prefix = "ssm_profile"
  role = "${aws_iam_role.ssm_ec2_role.name}"
}

resource "aws_iam_role" "ssm_ec2_role" {
  name_prefix = "ssm_ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags = {
    Name = "ssm_ec2_role"
    Project = "${var.ProjectTag}"
    Environment = "${var.Environment}"
  }
}
resource "aws_iam_role_policy_attachment" "ssm_ec2_role_ssm_policy" {
  role       = "${aws_iam_role.ssm_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy" "ssm_ec2_access" {
  name_prefix = "ssm_ec2_access"
  role = "${aws_iam_role.ssm_ec2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}