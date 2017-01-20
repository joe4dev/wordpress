#
# Cookbook Name:: wordpress
# Library:: wp_cli
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

module Wordpress
  class WpCli
    attr_reader :bin
    # @param root [String] the wordpress root directory (i.e., parent_dir)
    # @param user [String] the wordpress system user
    # @param bin [String] assume that wp is within the PATH if passed nothing or nil
    def initialize(root, user, bin = nil)
      @root = root
      @user = user
      @bin = bin
    end

    # Required opts: url, title, admin_user, admin_password, admin_email
    def install_core!(opts)
      unless core_installed?
        run_cmd(wp_cmd("core install #{options_string(opts)}"))
        Chef::Log.info('Installed the wordpress core.')
      end
    end

    def update_url!(new_url)
      if siteurl != new_url || home != new_url
        run_cmd(wp_cmd("option update home #{new_url}"))
        run_cmd(wp_cmd("option update siteurl #{new_url}"))
        Chef::Log.info("Updated the Wordpress url to #{new_url}.")
      end
    end

    def install_plugin!(name, opts = {})
      unless plugin_installed?(name)
        run_cmd(wp_cmd("plugin install #{name} --activate #{options_string(opts)}"))
        Chef::Log.info("Installed and activated the Wordpress plugin #{name} #{options_string(opts)}.")
      end
    # Workaround for plugin URLs where `plugin install` fails if already installed
    # and `plugin_installed` doesn't match the URL as `name`
    rescue => e
      if e.message.include?('Warning: Destination folder already exists.')
        Chef::Log.warn("Plugin from #{name} is already downloaded and thus will be ignored.")
      else
        raise e
      end
    end

    def plugin_installed?(name)
      cmd = run_cmd(wp_cmd("plugin is-installed #{name}"), no_error: true)
      !cmd.error?
    end

    def wp_cmd(command)
      "#{wp} #{command}"
    end

    def wp
      bin.nil? ? 'wp' : "php #{@bin}"
    end

    def siteurl
      run_cmd(wp_cmd('option get siteurl')).stdout.strip
    end

    def home
      run_cmd(wp_cmd('option get home')).stdout.strip
    end

    def core_installed?
      cmd = run_cmd(wp_cmd('core is-installed'), no_error: true)
      !cmd.error?
    #   true
    # rescue => e
    #   no_output = "STDOUT: \nSTDERR: \n----"
    #   e.message.include?(no_output) ? (return false) : (raise e)
    end

    # Runs a command in the context of wordpress
    # @params opts[:no_error] = true don't fail when an error happens
    # @returns [Mixlib::ShellOut] the runned command
    def run_cmd(cmd, opts = {})
      cmd = Mixlib::ShellOut.new(cmd, cwd: @root, user: @user)
      cmd.run_command
      cmd.error! unless opts[:no_error] == true
      cmd
    end

    private

      # Converts an options hash (e.g., { key: value }) into
      # String command line options (e.g., --key=value)
      def options_string(opts)
        options = ''
        opts.each do |key, value|
          options << "--#{key}=\"#{value}\" "
        end
        options
      end
  end
end
