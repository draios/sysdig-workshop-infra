# # encoding: utf-8

# Inspec test for recipe habitat_workstation::docker_compose
describe command('/usr/local/bin/docker-compose') do
  it { should exist }
end
