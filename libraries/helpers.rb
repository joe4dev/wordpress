#
# Cookbook Name:: wordpress
# Library:: helpers
# Author:: Yvo van Doorn <yvo@getchef.com>
# Author:: Julian C. Dunn <jdunn@getchef.com>
# Author:: Joel Scheuner (<joel.scheuner.dev@gmail.com>)
#
# Copyright 2013, Chef Software, Inc.
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

module Wordpress
  module Helpers
    def is_local_host?(host)
      if host == 'localhost' || host == '127.0.0.1' || host == '::1'
        true
      else
        require 'socket'
        require 'resolv'
        Socket.ip_address_list.map { |a| a.ip_address }.include? Resolv.getaddress host
      end
    end

    def self.make_db_query(user, pass, query)
      %< --user=#{user} --password="#{pass}" --execute="#{query}">
    end

    def default_ip
      query_public_ip
    end

    # Detects Vagrant environment based on the `/vagrant` mountpoint
    # @returns true if in a Vagrant environment, false otherwise
    def vagrant?
      node['filesystem']['vagrant']['mount'] == '/vagrant' rescue false
    end

    # Detects Virtualbox environment based on ohai virtualization information
    # @returns true if in a virtualbox environment, false otherwise
    def virtualbox?
      node['virtualization']['systems']['vbox'] == 'guest' rescue false
    end

    # Assuming `private_network` config with static IP in the Vagrantfile
    def guess_virtualbox_ip
      node['network']['interfaces']['eth1']['routes'][0]['src'] rescue nil
    end

    def query_public_ip
      Mixlib::ShellOut.new(node['wordpress']['public_ip_query']).run_command.stdout
    end
  end
end
