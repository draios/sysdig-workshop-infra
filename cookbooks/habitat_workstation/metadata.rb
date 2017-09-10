name 'habitat_workstation'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'all_rights'
description 'Installs/Configures habitat_workstation'
long_description 'Installs/Configures habitat_workstation'
version '0.3.0'
issues_url 'https://github.com/nathenharvey/habitat_workstation/issues' if respond_to?(:issues_url)
source_url 'https://github.com/nathenharvey/habitat_workstation' if respond_to?(:source_url)

depends 'docker'
depends 'sudo'
depends 'ufw'
depends 'habitat'
depends 'yum-epel'