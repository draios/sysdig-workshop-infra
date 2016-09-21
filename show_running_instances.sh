#!/bin/sh

aws ec2 describe-instances --query  'Reservations[*].Instances[*].[InstanceId,ImageId,PublicIpAddress,State.Name,Tags[?Key==`Name`].Value[]]' --output text | grep running | grep $AMI_ID
