name             'wordpress'
maintainer       "Brint O'Hearn"
maintainer_email 'cookbooks@opscode.com'
license          'Apache 2.0'
description      'Installs/Configures WordPress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.2.0'

%w{ php openssl yum-mysql-community }.each do |cb|
  depends cb
end

depends 'apt', '>= 0.0.0'
depends 'apache2', '~> 3.2.2'
depends 'database', '~> 6.1.1'
depends 'mysql', '>= 6.0.0'
depends 'mysql2_chef_gem', '~> 1.1.0'
depends 'tar', '~> 1.1.0'
depends 'php-fpm', '~> 0.7.6'
depends 'selinux', '~> 0.9.0'

%w{ debian ubuntu windows centos redhat scientific oracle }.each do |os|
  supports os
end
