#
# Cookbook:: habitat_workstation
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'habitat_workstation::docker_compose' do
  before do
    # avoid breaking all of core chef wherever it calls File.exist? with other arguments
    allow(File).to receive(:exist?).and_call_original
  end

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

    it 'downloads docker-compose' do
      expect(File).to receive(:exist?).with("/usr/local/bin/docker-compose").and_return(false)
      expect(chef_run).to run_execute('download docker-compose')
    end

    it 'chmods the docker-compose file' do
      expect(chef_run).to_not run_execute('chmod the docker-compose file').with(command: 'chmod +x /usr/local/bin/docker-compose')
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

    it 'downloads docker-compose' do
      expect(File).to receive(:exist?).with("/usr/local/bin/docker-compose").and_return(false)
      expect(chef_run).to run_execute('download docker-compose')
    end

    it 'chmods the docker-compose file' do
      expect(chef_run).to_not run_execute('chmod the docker-compose file').with(command: 'chmod +x /usr/local/bin/docker-compose')
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

    it 'downloads docker-compose' do
      expect(File).to receive(:exist?).with("/usr/local/bin/docker-compose").and_return(false)
      expect(chef_run).to run_execute('download docker-compose')
    end

    it 'chmods the docker-compose file' do
      expect(chef_run).to_not run_execute('chmod the docker-compose file').with(command: 'chmod +x /usr/local/bin/docker-compose')
    end
  end
end
