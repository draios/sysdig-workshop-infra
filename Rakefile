require 'erb'
require 'mixlib/shellout'
require 'parallel'
require 'yaml'

namespace :ami do
  desc 'Build AMI'
  task :build, :template, :version do |_, args|
    build_ami(args[:template], args[:version])
  end

  desc 'Build all AMIs in parallel'
  task :build_all, :version do |_, args|
    Parallel.map(templates, in_threads: 4 ) do |t|
      build_ami(t, args[:version])
    end
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
    shell_out_command('rm -rf cookbooks/habitat_workstation/Berksfile.lock vendored-cookbooks/*')
    shell_out_command('berks vendor -b cookbooks/habitat_workstation/Berksfile vendored-cookbooks/')
  end
end


desc 'Create a CloudFormation template for N hosts'
task :deploy, :name, :num_hosts, :ttl do |_, args|
  update_template(args[:name], args[:num_hosts], args[:ttl])
  create_stack(args[:name])
end

namespace :list do
  desc 'List IPs of running CloudFormation stack'
  task :ips, :stack do |_, args|
    list_ips(args[:stack])
  end

  desc 'List AMIs from logs'
  task :amis do
    gather_results
  end

  desc 'List available templates'
  task :templates do
    puts templates
  end
end

def a_to_s(*args)
  clean_array(*args).join(" ")
end

def build_ami(template, ver)
  ver = ver.nil? ? 'latest' : ver
  cmd = %W(packer build packer/#{template}.json | tee #{log(template, ver)})
  cmd.insert(2, "-var hab_version=#{ver}")
  cmd.join(' ')
  shell_out_command(cmd)
end

def clean_array(*args)
  args.flatten.reject { |i| i.nil? || i == '' }.map(&:to_s)
end

def conf
  if File.exist?('config.yml')
    YAML.load(File.read('config.yml'))
  else
    puts 'No config.yml found, using example values'
    YAML.load(File.read('config.example.yml'))
  end
end

def create_stack(name)
  cmd = %W(aws cloudformation create-stack)
  cmd.insert(3, "--stack-name #{name}")
  cmd.insert(4, "--template-body file://stacks/#{name}.cfn.yml")
  cmd.join(' ')
  shell_out_command(cmd)
end

def fetch_env(var)
  env_var = ENV[var]
  unless env_var
    puts "No #{var} environment variable has been specified"
    exit
  end
  env_var
end

def gather_results
  pattern = '..-.*-.: ami-.*'
  h = { }
  if logs != '*'
    logs.each do |log|
      match = File.read("logs/#{log}.log").split("\n").grep(/#{pattern}/).first.delete(':').split
      region = match[0]
      ami = match[1]
      h[log] = {
        region => ami
      }
    end
    puts 'Parsing logs and writing ./results.yml'
    File.open("results.yml", 'w') { |file| file.puts h.to_yaml }
    puts h.to_yaml
  else
    puts 'No logs found in logs/'
  end
end

def list_ips(name)
  cmd = %W(aws cloudformation describe-stacks)
  cmd.insert(3, "--stack-name #{name}")
  cmd.insert(4, "| jq -r '.Stacks[].Outputs[] | \"\\(.OutputKey): \\(.OutputValue)\"' | sort")
  cmd.join(' ')
  shell_out_command(cmd)
end

def log(template, ver)
  "logs/#{template}-hab-#{ver}.log"
end

def logs
  globs = "*.log"
  Dir.chdir('logs') do
    Array(globs).
      map { |glob| result = Dir.glob("#{glob}"); result.empty? ? glob : result }.
      flatten.
      sort.
      map { |template| template.sub(/\.log$/, '') }
  end
end

def shell_out_command(command)
  cmd = Mixlib::ShellOut.new(a_to_s(command), :timeout => 900, live_stream: STDOUT)
  cmd.run_command
  cmd
end

def templates
  globs = "*.json"
  Dir.chdir('packer') do
    Array(globs).
      map { |glob| result = Dir.glob("#{glob}"); result.empty? ? glob : result }.
      flatten.
      sort.
      map { |template| template.sub(/\.json$/, '') }
  end
end

def update_template(name, num_hosts, ttl)
  @conf = conf
  @term_date = (Time.now + (ttl.to_i * 86400)).strftime("%Y-%m-%d")
  @ami_id = fetch_env('AMI_ID')
  @keypair = fetch_env('AWS_KEYPAIR_NAME')
  @workstations = num_hosts.to_i
  rendered_cfn = ERB.new(File.read('templates/cfn.yml.erb'), nil, '-').result(binding)
  File.open("stacks/#{name}.cfn.yml", 'w') { |file| file.puts rendered_cfn }
  puts "Updated stacks/#{name}.cfn.yml"
end
