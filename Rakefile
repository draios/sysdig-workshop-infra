require 'yaml'
require 'erb'
require 'mixlib/shellout'
require 'deep_merge'

namespace :ami do
  desc 'Build AMI'
  task :build, :template, :version do |_, args|
    Rake::Task['cookbook:vendor'].invoke # we only want to run this once
    ver = args[:version].nil? ? 'latest' : args[:version]
    cmd = %W(packer build packer/#{args[:template]}.json | tee #{log(args[:template], ver)})
    cmd.insert(2, "-var hab_version=#{ver}")
    cmd.join(' ')
    sh a_to_s(cmd)
    parse_ami(args[:template], ver)
  end

  desc 'Build all AMIs'
  task :build_all, :version do |_, args|
    templates.each do |t|
      Rake::Task['ami:build'].invoke(t, args[:version])
      Rake::Task['ami:build'].reenable
    end
  end

  desc 'Deploy a CloudFormation template for N hosts'
  task :deploy, :name, :num_hosts do |_, args|
    update_template(args[:name], args[:num_hosts])
    sh "aws cloudformation create-stack --stack-name #{args[:name]} --template-body file://stacks/#{args[:name]}.cfn.yml"
  end

  desc 'Grant Subscribers access to Image (AMI_ID=????????)'
  task :share do
    ami_id = fetch_ami_id

    aws_subscribers = YAML.load(File.read('./subscribers.yml'))["aws"]

    aws_subscribers.each do |user_id|
      puts "Granting #{user_id} launch permission to #{ami_id}"
      `aws ec2 modify-image-attribute --image-id #{ami_id} --launch-permission "{\\"Add\\":[{\\"UserId\\":\\"#{user_id}\\"}]}"`
    end
  end
end

namespace :cookbook do
  desc 'Vendor Cookbooks'
  task :vendor do
    sh "rm -rf cookbooks/habitat_workstation/Berksfile.lock vendored-cookbooks/*"
    sh "berks vendor -b cookbooks/habitat_workstation/Berksfile vendored-cookbooks/"
  end
end

namespace :list do
  desc 'List IPs of running workstations'
  task :ips, :name do |_, args|
    sh "aws cloudformation describe-stacks --stack-name #{args[:name]} | jq -r '.Stacks[].Outputs[] | \"\\(.OutputKey): \\(.OutputValue)\"' | sort"
  end
end

def a_to_s(*args)
  clean_array(*args).join(" ")
end

def clean_array(*args)
  args.flatten.reject { |i| i.nil? || i == "" }.map(&:to_s)
end

def results
  File.write("results.yml", "") unless File.exist?('results.yml')
  YAML.load(File.read('results.yml'))
end

def fetch_ami_id
  ami_id = ENV['AMI_ID']
  unless ami_id
    puts "No AMI_ID environment variable has been specified"
    exit
  end
  ami_id
end

def fetch_env(var)
  env_var = ENV[var]
  unless env_var
    puts "No #{var} environment variable has been specified"
    exit
  end
  env_var
end

def log(template, ver)
  "logs/#{template}-hab-#{ver}.log"
end

def parse_ami(template, ver)
  pattern = "..-.*-.: ami-.*"
  artifact = File.read(log(template, ver)).split("\n").grep(/#{pattern}/).first.delete(':').split
  region = artifact[0]
  ami = artifact[1]
  h = {}
  h[region] = {
    template => {
      ver => ami
    }
  }
  merged = !results ? h : results.deep_merge(h)
  File.open("results.yml", 'w') { |file| file.puts merged.to_yaml }
end

def update_template(name, hosts)
  @ami_id = fetch_env('AMI_ID')
  @keypair = fetch_env('AWS_KEYPAIR_NAME')
  @workstations = hosts.to_i
  rendered_cfn = ERB.new(File.read("templates/cfn.yml.erb"), nil, '-').result(binding)
  File.open("stacks/#{name}.cfn.yml", 'w') { |file| file.puts rendered_cfn }
  puts "Updated stacks/#{name}.cfn.yml"
end

def templates
  globs = "*.json"
  Dir.chdir('packer') do
    Array(globs).
      map { |glob| result = Dir.glob("#{glob}"); result.empty? ? glob : result }.
      flatten.
      sort.
      delete_if { |file| file =~ /\.variables\./ }.
      map { |template| template.sub(/\.json$/, '') }
  end
end
