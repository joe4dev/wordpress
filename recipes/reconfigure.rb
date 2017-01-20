#
# Cookbook Name:: wordpress
# Recipe:: reconfigure
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

ruby_block 'update_site_url' do
  block do
    wp = Wordpress::WpCli.new(node['wordpress']['dir'],
                                 node['wordpress']['install']['user'],
                                 node['wordpress']['wp_cli_bin'])
    # Reconfigure the url of the wordpress instance
    wp.update_url!(node['wordpress']['site']['url'])
  end
  action :run
end

ruby_block 'install_plugins' do
  block do
    wp = Wordpress::WpCli.new(node['wordpress']['dir'],
                                 node['wordpress']['install']['user'],
                                 node['wordpress']['wp_cli_bin'])
    node['wordpress']['plugins'].each do |id, plugin|
      wp.install_plugin!(plugin)
    end
  end
  action :run
  # Workaround plugin installation via URL that might fail on first attempt
  retries 2
end
