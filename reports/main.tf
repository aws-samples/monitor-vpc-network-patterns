# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
data "aws_caller_identity" "current" {}

resource "aws_glue_catalog_database" "flowlogs" {
  name = "flowlogs"
}

resource "aws_glue_catalog_table" "flowlogsA" {
  name          = "flowlogsa"
  database_name = "${aws_glue_catalog_database.flowlogs.name}"

  table_type = "EXTERNAL_TABLE"

    partition_keys {
      name = "dt"
      type = "string"
    }

  parameters = {
    EXTERNAL              = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.BucketA}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${var.region}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = true

    ser_de_info {
      name                  = "vpcflowlog"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "serialization.format" = " "
        "field.delim" = " "
        "compressionType" = "gzip"
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "vpcid"
      type = "string"
    }
    columns {
      name = "subnetid"
      type = "string"
    }
    columns {
      name = "instanceid"
      type = "string"
    }
    columns {
      name = "interfaceid"
      type = "string"
    }
    columns {
      name = "account"
      type = "string"
    }
    columns {
      name = "traffictype"
      type = "string"
    }
    columns {
      name = "sourceaddr"
      type = "string"
    }
    columns {
      name = "destinationaddr"
      type = "string"
    }
    columns {
      name = "sourceport"
      type = "int"
    }
    columns {
      name = "destport"
      type = "int"
    }
    columns {
      name = "packetsourceaddress"
      type = "string"
    }
    columns {
      name = "packetdestinationaddress"
      type = "string"
    }
    columns {
      name = "protocol"
      type = "int"
    }
    columns {
      name = "numbytes"
      type = "bigint"
    }
    columns {
      name = "numpackets"
      type = "int"
    }
    columns {
      name = "starttime"
      type = "int"
    }
    columns {
      name = "endtime"
      type = "int"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "tcpflags"
      type = "int"
    }
    columns {
      name = "logstatus"
      type = "string"
    }
  }
}
resource "aws_glue_catalog_table" "flowlogsB" {
  name          = "flowlogsb"
  database_name = "${aws_glue_catalog_database.flowlogs.name}"

  table_type = "EXTERNAL_TABLE"

    partition_keys {
      name = "dt"
      type = "string"
    }

  parameters = {
    EXTERNAL              = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.BucketB}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${var.region}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = true

    ser_de_info {
      name                  = "vpcflowlog"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "serialization.format" = " "
        "field.delim" = " "
        "compressionType" = "gzip"
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "vpcid"
      type = "string"
    }
    columns {
      name = "subnetid"
      type = "string"
    }
    columns {
      name = "instanceid"
      type = "string"
    }
    columns {
      name = "interfaceid"
      type = "string"
    }
    columns {
      name = "account"
      type = "string"
    }
    columns {
      name = "traffictype"
      type = "string"
    }
    columns {
      name = "sourceaddr"
      type = "string"
    }
    columns {
      name = "destinationaddr"
      type = "string"
    }
    columns {
      name = "sourceport"
      type = "int"
    }
    columns {
      name = "destport"
      type = "int"
    }
    columns {
      name = "packetsourceaddress"
      type = "string"
    }
    columns {
      name = "packetdestinationaddress"
      type = "string"
    }
    columns {
      name = "protocol"
      type = "int"
    }
    columns {
      name = "numbytes"
      type = "bigint"
    }
    columns {
      name = "numpackets"
      type = "int"
    }
    columns {
      name = "starttime"
      type = "int"
    }
    columns {
      name = "endtime"
      type = "int"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "tcpflags"
      type = "int"
    }
    columns {
      name = "logstatus"
      type = "string"
    }
  }
}
resource "aws_glue_catalog_table" "flowlogsC" {
  name          = "flowlogsc"
  database_name = "${aws_glue_catalog_database.flowlogs.name}"

  table_type = "EXTERNAL_TABLE"

    partition_keys {
      name = "dt"
      type = "string"
    }

  parameters = {
    EXTERNAL              = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.BucketC}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${var.region}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = true

    ser_de_info {
      name                  = "vpcflowlog"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "serialization.format" = " "
        "field.delim" = " "
        "compressionType" = "gzip"
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "vpcid"
      type = "string"
    }
    columns {
      name = "subnetid"
      type = "string"
    }
    columns {
      name = "instanceid"
      type = "string"
    }
    columns {
      name = "interfaceid"
      type = "string"
    }
    columns {
      name = "account"
      type = "string"
    }
    columns {
      name = "traffictype"
      type = "string"
    }
    columns {
      name = "sourceaddr"
      type = "string"
    }
    columns {
      name = "destinationaddr"
      type = "string"
    }
    columns {
      name = "sourceport"
      type = "int"
    }
    columns {
      name = "destport"
      type = "int"
    }
    columns {
      name = "packetsourceaddress"
      type = "string"
    }
    columns {
      name = "packetdestinationaddress"
      type = "string"
    }
    columns {
      name = "protocol"
      type = "int"
    }
    columns {
      name = "numbytes"
      type = "bigint"
    }
    columns {
      name = "numpackets"
      type = "int"
    }
    columns {
      name = "starttime"
      type = "int"
    }
    columns {
      name = "endtime"
      type = "int"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "tcpflags"
      type = "int"
    }
    columns {
      name = "logstatus"
      type = "string"
    }
  }
}