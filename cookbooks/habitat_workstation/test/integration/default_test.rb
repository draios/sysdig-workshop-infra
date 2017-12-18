# # encoding: utf-8

# Inspec test for recipe habitat_workstation::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe user('hab') do
  it { should exist }
end

describe group('hab') do
  it { should exist }
end

%w( git tree emacs nano jq curl tmux ).each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# the vim package may be vim-enhanced or vim
describe.one do
  describe package('vim') do
    it { should be_installed }
  end

  describe package('vim-enhanced') do
    it { should be_installed }
  end
end

describe user('chef') do
  it { should exist }
  its('groups') { should include 'docker' }
end

describe port('22') do
  it { should be_listening }
end

describe port('443') do
  it { should be_listening }
end
