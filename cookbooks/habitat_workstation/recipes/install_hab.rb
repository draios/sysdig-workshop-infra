#
# Cookbook Name:: habitat_workstation
# Recipe:: install_hab
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

hab_install 'install habitat' do
  version node['hab']['version']
end

link '/usr/bin/hab' do
  to '/usr/local/hab/hab'
end

