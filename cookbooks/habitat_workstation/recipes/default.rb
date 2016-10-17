#
# Cookbook Name:: habitat_workstation
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

if (node["platform_family"] == "debian")
  include_recipe 'ufw::disable'
end

apt_update 'periodic apt update' do
  action :periodic
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

%w( git tree vim emacs nano ).each do |p|
  package p
end

docker_service 'default' do
  action [:create, :start]
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


if node['platform_family'] == 'rhel'
  service 'sshd'

  template '/etc/ssh/sshd_config' do
    source 'rhel-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[sshd]"
  end

  directory '/etc/cloud' do
    recursive true
  end

  template '/etc/cloud/cloud.cfg' do
    source 'cloud.cfg.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end
end

if node['platform_family'] == 'debian'
  service 'ssh'

  template '/etc/ssh/sshd_config' do
    source 'debian-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, "service[ssh]"
  end
end
