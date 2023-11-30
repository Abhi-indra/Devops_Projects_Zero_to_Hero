#!/bin/bash

#############################################
# Author: Abhishek                          #
# Date: 30-Nov-2023                         #
#                                           #
# Version: v1                               #
#                                           #
# This script will report the aws resources.#
#                                           #
#############################################
#                                           #
# Resources to monitor is:                  #
# AWS EC2, S3, Lambda, IAM users            #
#                                           #
#############################################

# list S3 Buckets:
echo "list of S3 buckets"
aws s3 ls

# list EC2 instances:
echo "list of EC2"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

# list aws lambda 
echo "list of lambda"
aws lambda list-functions

# list IAM users
echo "list of IAM"
