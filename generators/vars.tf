# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
variable "ProjectTag" { }
variable "Environment" { }
variable "ami" { }
variable "subnet" { }
variable "instance_type" { 
    default = "t3.medium"
}
variable "sg" { 
    type = "list"
}
variable "num_workers" { 
    default = "2"
}
variable region {}