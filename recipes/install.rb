#
# Cookbook Name:: wordpress
# Recipe:: install
#
# Copyright 2017, Joel Scheuner.
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

# mod_php5 (used by Wordpress) requires non-threaded MPM such as prefork
# @see apache2/recipes/mod_php5.rb:22
# @see attributes https://github.com/svanzoest-cookbooks/apache2/#prefork-attributes
# A warning is yielded otherwise during the Chef run
node.default['apache']['mpm'] = 'prefork'

include_recipe "wordpress::database"
include_recipe "wordpress::apache"
