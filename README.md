# Habitat Workstation

Cookbooks and Packer config to create a workstation for use during Habitat training.

## Current Amazon Machine Image IDs

* Introduction to Habitat Workstation - CentOS 7
  * ami-85720c92
* Introduction to Habitat Workstation - Ubuntu 14.04
  * ami-860c7591

## Build the Amazon Machine Images (AMIs)

`$ packer build packer/centos-7.json`

or

`$ packer build packer/ubuntu-1404.json`

## Share the AMIs with other Amazon accounts

```bash
$ export AMI_ID=the_ami_id_generated_by_packer
$ rake ami:share
```

## Build out Workstations for a Classroom

```bash
$ export AMI_ID=the_ami_id_generated_by_packer
$ build_habitat_workstations.sh [number] [name] [department] [contact] [project] [termination-date]
```

e.g.
```bash
$ export AMI_ID=the_ami_id_generated_by_packer
$ build_habitat_workstations.sh 20 "Surge Conf 2016" "Community Engineering" "Nathen Harvey" "Surge" "2016-09-23"
```

## List Workstations for a Classroom

```
$ export AMI_ID=the_ami_id_generated_by_packer
$ show_running_instances.sh
```