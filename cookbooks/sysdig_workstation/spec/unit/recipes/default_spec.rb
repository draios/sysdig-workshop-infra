#
# Cookbook Name:: sysdig_workstation
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'sysdig_workstation::default' do
  context 'When all attributes are default, on Ubuntu 14.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the "hab" group' do
      expect(chef_run).to create_group('hab').with(members: ['hab'])
    end

    it 'creates the "hab" user' do
      expect(chef_run).to create_user('hab')
    end

    it 'installs all packages when given an array of names' do
      expect(chef_run).to install_package(%w( git tree vim emacs nano jq curl tmux ))
    end

    it 'creates the default docker service' do
      expect(chef_run).to create_docker_service('default')
    end

    it 'starts the default docker service' do
      expect(chef_run).to start_docker_service('default')
    end
  end

  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the "hab" group' do
      expect(chef_run).to create_group('hab').with(members: ['hab'])
    end

    it 'creates the "hab" user' do
      expect(chef_run).to create_user('hab')
    end

    it 'installs all packages when given an array of names' do
      expect(chef_run).to install_package(%w( git tree vim emacs nano jq curl tmux ))
    end

    it 'creates the default docker service' do
      expect(chef_run).to create_docker_service('default')
    end

    it 'starts the default docker service' do
      expect(chef_run).to start_docker_service('default')
    end
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the "hab" group' do
      expect(chef_run).to create_group('hab').with(members: ['hab'])
    end

    it 'creates the "hab" user' do
      expect(chef_run).to create_user('hab')
    end

    it 'installs all packages when given an array of names' do
      expect(chef_run).to install_package(%w( git tree vim emacs nano jq curl tmux ))
    end

    it 'creates the default docker service' do
      expect(chef_run).to create_docker_service('default')
    end

    it 'starts the default docker service' do
      expect(chef_run).to start_docker_service('default')
    end
  end
end
