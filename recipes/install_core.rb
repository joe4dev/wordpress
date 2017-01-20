#
# Cookbook Name:: wordpress
# Recipe:: install_core
# Author:: Joel Scheuner (<joel.scheuner.dev@gmail.com>)
#
# Copyright (C) 2017, Joel Scheuner.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install_wp_cli
directory File.basename(node['wordpress']['wp_cli_bin']) do
  action :create
  recursive true
end
remote_file node['wordpress']['wp_cli_bin'] do
  mode '0744'
  source node['wordpress']['wp_cli_url']
end

# Install WordPress core
site = node['wordpress']['site']
ruby_block 'install_wp_core' do
  block do
    wp = Wordpress::WpCli.new(node['wordpress']['dir'],
                                 node['wordpress']['install']['user'],
                                 node['wordpress']['wp_cli_bin'])
    wp.install_core!(url: site['url'],
                     title: site['title'],
                     admin_user: site['admin_user'],
                     admin_password: site['admin_password'],
                     admin_email: site['admin_email'])
  end
  action :run
end

include_recipe 'wordpress::reconfigure'
