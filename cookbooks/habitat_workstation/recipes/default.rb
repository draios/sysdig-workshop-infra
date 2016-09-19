#
# Cookbook Name:: habitat_workstation
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

apt_update 'periodic apt update' do
  action :periodic
end

%w( git tree vim emacs nano ).each do |p|
  package p
end

user 'hab' do
  manage_home false
  system true
  uid 500
end

group 'hab' do
  members ['hab']
  gid 500
end

docker_service 'default' do
  action [:create, :start]
end

template "/etc/selinux/config" do
  source "selinux-config.erb"
  mode "0644"
end

service 'sshd'

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[sshd]"
end

template '/home/ec2-user/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[sshd]"
end

user 'chef' do
  comment 'ChefDK User'
  manage_home true
  home '/home/chef'
  shell '/bin/bash'
  supports :manage_home => true
  password '$1$seaspong$/UREL79gaEZJRXoYPaKnE.'
  action :create
end

sudo 'chef' do
  template "chef-sudoer.erb"
end

template '/etc/cloud/cloud.cfg' do
  template 'cloud.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
# execute "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config" do
#   notifies :restart, "service[sshd]"
# end