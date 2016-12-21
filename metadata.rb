name             'wordpress'
maintainer       "Brint O'Hearn"
maintainer_email 'cookbooks@opscode.com'
license          'Apache 2.0'
description      'Installs/Configures WordPress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.1.0'

%w{ php openssl }.each do |cb|
  depends cb
end

depends 'apache2', '>= 2.0.0'
depends 'database', '>= 1.6.0'
depends 'mysql', '~> 6.1.3'
depends 'mysql2_chef_gem', '~> 1.0.1'
depends 'tar', '>= 0.3.1'
depends 'php-fpm', '~> 0.6.10'
depends 'selinux', '~> 0.7'

%w{ debian ubuntu windows centos redhat scientific oracle }.each do |os|
  supports os
end
