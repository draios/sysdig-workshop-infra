name 'falco_workstation'
maintainer 'Michael Ducy'
maintainer_email 'michael@sysdig.com'
license 'Apache-2.0'
description 'Installs/Configures falco_workstation'
long_description 'Installs/Configures falco_workstation'
version '0.1.0'
issues_url 'https://github.com/mfdii/sysdig_workstation/issues' if respond_to?(:issues_url)
source_url 'https://github.com/mfdii/sysdi_workstation' if respond_to?(:source_url)

chef_version '>= 12.1' if respond_to?(:chef_version)

%w(centos ubuntu).each do |os|
  supports os
end

depends 'docker'
depends 'sudo'
depends 'ufw'
depends 'yum-epel'
