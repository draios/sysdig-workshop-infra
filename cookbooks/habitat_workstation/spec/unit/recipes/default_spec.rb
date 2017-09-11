#
# Cookbook Name:: habitat_workstation
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'habitat_workstation::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    # it 'updates apt caches periodically' do
    #   expect(chef_run).to periodic_apt_update('default_action')
    # end

    it 'creates the "hab" group' do
      expect(chef_run).to create_group('hab').with(members: ['hab'])
    end

    it 'creates the "hab" user' do
      expect(chef_run).to create_user('hab')
    end

    %w( git tree vim emacs nano ).each do |p|
      it 'installs #{p}' do
        expect(chef_run).to install_package p
      end
    end

    it 'creates the default docker service' do
      expect(chef_run).to create_docker_service('default')
    end

    it 'starts the default docker service' do
      expect(chef_run).to start_docker_service('default')
    end
  end
end
