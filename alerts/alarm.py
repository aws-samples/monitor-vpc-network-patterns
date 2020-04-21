# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
import boto3
import json
import logging
import traceback
import os
import time
import ipaddr

# Create AWS clients
sns = boto3.client('sns')
ec2 = boto3.client('ec2')

# Constants
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# Env variables
TOPIC_ARN = os.environ['TOPIC_ARN']

"""
We want to detect any routes created, updated, or deleted, that affect routes that go outside the VPC.

Example event:

{
    "version": "0",
    "id": "cf2cd0c9-6ac0-21a3-9573-7f789fd531ae",
    "detail-type": "AWS API Call via CloudTrail",
    "source": "aws.ec2",
    "account": "xxxx",
    "time": "2020-04-01T18:58:21Z",
    "region": "us-east-2",
    "resources": [],
    "detail": {
        "eventVersion": "1.05",
        "userIdentity": {
            "type": "IAMUser",
            "principalId": "xxx",
            "arn": "arn:aws:iam::xxx:user/xxx",
            "accountId": "xxx",
            "accessKeyId": "xxx",
            "userName": "xxx",
            "sessionContext": {
                "sessionIssuer": {},
                "webIdFederationData": {},
                "attributes": {
                    "mfaAuthenticated": "true",
                    "creationDate": "2020-04-01T15:04:02Z"
                }
            }
        },
        "eventTime": "2020-04-01T18:58:21Z",
        "eventSource": "ec2.amazonaws.com",
        "eventName": "CreateRoute",
        "awsRegion": "us-east-2",
        "sourceIPAddress": "x.x.x.x",
        "userAgent": "console.ec2.amazonaws.com",
        "requestParameters": {
            "routeTableId": "rtb-xxx",
            "destinationCidrBlock": "192.1.0.0/16",
            "gatewayId": "igw-xxx"
        },
        "responseElements": {
            "requestId": "f9146924-e793-41b6-861d-566c6ef1d8ba",
            "_return": true
        },
        "requestID": "f9146924-e793-41b6-861d-566c6ef1d8ba",
        "eventID": "c9af729e-12cd-4809-b24e-f67d39734a61",
        "eventType": "AwsApiCall"
    }
}
"""
def handler(event, context):

    try:
        LOGGER.info("Event metadata: {0}".format(json.dumps(event)))
        rtable = event['detail']['requestParameters']['routeTableId']
        dest_cidr = event['detail']['requestParameters']['destinationCidrBlock']

        LOGGER.info("Getting details about route table {0}".format(rtable))
        response = ec2.describe_route_tables(
            DryRun=False,
            RouteTableIds=[
                rtable
            ]
        )

        vpc = response['RouteTables'][0]['VpcId']
        LOGGER.info("Route table {0} belongs to vpc {1}".format(rtable, vpc))

        response = ec2.describe_vpcs(
            VpcIds=[
                vpc,
            ],
            DryRun=False
        )

        cidr_block = response['Vpcs'][0]['CidrBlock']
        LOGGER.info("Route table {0} belongs to vpc {1} with CIDR {2}".format(rtable, vpc, cidr_block))

        n1 = ipaddr.IPNetwork(cidr_block)
        n2 = ipaddr.IPNetwork(dest_cidr)

        if n2.overlaps(n1):
            LOGGER.info("Destination CIDR block is part of VPC CIDR block, not sending alert")
        else:
            LOGGER.info("Destination CIDR block is not part of VPC CIDR block, sending alert")
            message = "Route table {0} in VPC {1} had an impactful change to the route table".format(rtable, vpc)
            sns.publish(
                TopicArn=TOPIC_ARN,
                Message=message,
                Subject='Route table modified'
            )


    except Exception as e:
        trc = traceback.format_exc()
        LOGGER.error("Failed processing event {0}: {1}\n\n{2}".format(json.dumps(event), str(e), trc))
