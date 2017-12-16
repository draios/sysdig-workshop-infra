#
# Cookbook:: habitat_workstation
# Recipe:: docker_compose
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'download docker-compose' do
  command "curl -sL https://github.com/docker/compose/releases/download/#{node['habitat_workstation']['docker_compose']['version']}/docker-compose-#{node['kernel']['name']}-#{node['kernel']['machine']} -o /usr/local/bin/docker-compose"
  not_if { ::File.exist?('/usr/local/bin/docker-compose') }
  notifies :run, 'execute[chmod the docker-compose file]', :immediately
  action :run
end

execute 'chmod the docker-compose file' do
  command 'chmod +x /usr/local/bin/docker-compose'
  action :nothing
end
