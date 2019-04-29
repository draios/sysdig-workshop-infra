#
# Cookbook Name:: sysdig_workstation
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'yum-epel::default'

apt_update 'periodic apt update' do
  action :periodic
end

package %w( git tree vim emacs nano jq curl tmux python-pip zip unzip socat )

docker_service 'default' do
  action [:create, :start]
end

user 'falco' do
  comment 'Falco User'
  manage_home true
  home '/home/falco'
  shell '/bin/bash'
  password '$1$ZcQEKWFP$ChM/Nb3B5rmwrq72nvfbI.'
  action :create
end

group 'docker' do
  action :modify
  members 'falco'
  append true
end

sudo 'falco' do
  template 'falco-sudoer.erb'
end

if node['platform_family'] == 'rhel'
  service 'sshd'

  package 'httpd-tools'

  execute 'allow port 443 for ssh' do
    command 'semanage port -m -t ssh_port_t  -p tcp 443'
    notifies :restart, 'service[sshd]'
  end

  template '/etc/ssh/sshd_config' do
    source 'rhel-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[sshd]'
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
  include_recipe 'ufw::disable'
  service 'ssh'

  template '/etc/ssh/sshd_config' do
    source 'debian-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[ssh]'
  end

  package 'apache2-utils'

end

include_recipe 'falco_workstation::docker_compose'
