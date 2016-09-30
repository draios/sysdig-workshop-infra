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

%w( git tree emacs nano ).each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# the vim package may be vim-enhanced or vim
describe command('vim') do
  it { should exist }
end

describe user('chef') do
  it { should exist }
end

