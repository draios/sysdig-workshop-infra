# Habitat Workstation

Cookbooks and Packer config to create a workstation for use during Habitat training.

## Current Amazon Machine Image IDs

AMIs are currently only available in `us-east` region.

Platform     | Hab 0.15.0   | none
----         | ------       | ----
CentOS 7     | ami-0cf0e61b | ami-58c4cd4f
RedHat 7     | ami-07ffe910 | ami-9ac6cf8d
Ubuntu 14.04 | ami-c5f3e5d2 | ami-66c3ca71
Ubuntu 16.04 | ami-0bcadc1c | ami-c3c5ccd4

## Pre-requisites

```
# The name of the AWS KeyPair to use for deployment
export $AWS_KEYPAIR_NAME='your_aws_keypair_name'
```

*NOTE*: Ensure your `~/.aws/config` region is set to `us-east-1` pending region
abstraction.

An `~/.aws/config` file might look like:

```
[default]
region=us-east-1
aws_access_key_id = MYKEYID
aws_secret_access_key = MYACCESSKEY
```

## Build the Amazon Machine Images (AMIs)

### Without Habitat installed

`$ rake ami:build[centos-7,none]`

### With Habitat installed

`$ rake ami:build[ubuntu-1604,0.14.0]`

The latest version of Habitat will be installed, 
The version is for display purposes unless set to `none`

### List available templates

```
$ rake list:templates
centos-7
rhel-7
ubuntu-1404
ubuntu-1604
```

## Share the AMIs with other Amazon accounts

```bash
$ export AMI_ID=the_ami_id_generated_by_packer
$ rake ami:share
```

## Deploy a CloudFormation stack

This deploys a CloudFormation stack with the number of hosts and TTL (days). 
A template will be created in `stacks/` with the arguments above and values from `config.yml`.
An example, `config.example.yml`, is included

```bash
# rake deploy[name,num_hosts,ttl]

$ export AMI_ID=the_ami_id_generated_by_packer
$ rake deploy[habihacks-stack,10,3]
```

```
$ cat config.example.yml
---
contact: Human Chef
dept: Community Engineering
project: Habihacks
region: us-east-1
sg: sg-a1c3b1db
subnet: subnet-46b55431
type: t2.medium 
```

## List Workstation IPs for a CloudFormation stack

```bash
$ rake list:ips[habihacks-stack]
workstation1: 54.172.141.159
workstation2: 54.87.195.76
workstation3: 54.91.122.177
workstation4: 54.86.46.187
workstation5: 54.227.190.60
```
