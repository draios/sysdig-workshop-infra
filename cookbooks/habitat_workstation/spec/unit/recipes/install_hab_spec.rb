#
# Cookbook Name:: habitat_workstation
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'habitat_workstation::install_hab' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs hab' do
      expect(chef_run).to put_ark('hab')
    end

    it 'links hab' do
      expect(chef_run).to create_link('/usr/bin/hab')
    end
  end
end
