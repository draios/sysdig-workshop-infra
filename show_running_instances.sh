#!/bin/sh

# Introduction to Habitat Workstation - CentOS 7
# AMI="ami-85720c92"

# Introduction to Habitat Workstation - Ubuntu 14.04
AMI="ami-860c7591"


aws ec2 describe-instances --query  'Reservations[*].Instances[*].[InstanceId,ImageId,PublicIpAddress,State.Name,Tags[?Key==`Name`].Value[]]' --output text | grep running | grep $AMI
