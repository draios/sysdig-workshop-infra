name 'habitat_workstation'
maintainer 'Seth Thomas'
maintainer_email 'cheeseplus@chef.io'
license 'Apache-2.0'
description 'Installs/Configures habitat_workstation'
long_description 'Installs/Configures habitat_workstation'
version '0.4.0'
issues_url 'https://github.com/nathenharvey/habitat_workstation/issues' if respond_to?(:issues_url)
source_url 'https://github.com/nathenharvey/habitat_workstation' if respond_to?(:source_url)

chef_version '>= 12.1' if respond_to?(:chef_version)

%w(centos ubuntu).each do |os|
  supports os
end

depends 'docker'
depends 'sudo'
depends 'ufw'
depends 'habitat'
depends 'yum-epel'
