# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

cd alerts
rm -f alarm.zip
zip -r alarm.zip alarm.py ipaddr.py ipaddr-2.2.0.dist-info
cd ..