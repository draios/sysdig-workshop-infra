require 'yaml'

namespace :ami do
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

def fetch_ami_id
  ami_id = ENV['AMI_ID']
  unless ami_id
    puts "No AMI_ID environment variable has been specified"
    exit
  end
  ami_id
end
