#!/bin/sh
# Builds training instances in EC2
USAGE="Usage: $0 [number] [name] [department] [contact] [project] [termination-date]"
NUMHOSTS=$1
NAME=$2
DEPT=$3
CONTACT=$4
PROJECT=$5
TERM_DATE=$6

INSTANCE_TYPE="t2.medium"
KEY_NAME=$AWS_KEYPAIR_NAME

if [ "$#" -ne 6 ]; then
  echo $USAGE
  exit 1
fi

for host in $(aws ec2 run-instances --image-id $AMI_ID --region us-east-1 --count $NUMHOSTS --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids "sg-a1c3b1db" --subnet-id subnet-46b55431 | jq -r ".Instances|.[].InstanceId"); do
  echo "Created instance: $host"
  echo "Tagging $host with \"$NAME\""
  aws ec2 create-tags --resources $host --tags "Key=Name,Value=\"$NAME\""
  aws ec2 create-tags --resources $host --tags "Key=X-Dept,Value=\"$DEPT\""
  aws ec2 create-tags --resources $host --tags "Key=X-Contact,Value=\"$CONTACT\""
  aws ec2 create-tags --resources $host --tags "Key=X-Project,Value=\"$PROJECT\""
  aws ec2 create-tags --resources $host --tags "Key=X-Termination-Date,Value=\"$TERM_DATE\""
done
