#
# Cookbook Name:: habitat_workstation
# Recipe:: install_hab
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

ark 'hab' do
  url 'https://api.bintray.com/content/habitat/stable/linux/x86_64/hab-%24latest-x86_64-linux.tar.gz?bt_package=hab-x86_64-linux'
  action :put
end

link '/usr/bin/hab' do
  to '/usr/local/hab/hab'
end

