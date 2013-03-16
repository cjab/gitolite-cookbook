#
# Cookbook Name:: gitolite
# Recipe:: install
#
# Copyright 2013, Chad Jablonski
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

package "gitolite"

user node["gitolite"]["user"] do
  action :create
  system true
  shell  "/bin/bash"
  home   node["gitolite"]["directory"]
end


directory node["gitolite"]["directory"] do
  owner node["gitolite"]["user"]
  group node["gitolite"]["user"]
  mode  0700
  action :create
end


template "#{node["gitolite"]["directory"]}/.bashrc" do
  action :create
  owner  node["gitolite"]["user"]
  group  node["gitolite"]["user"]
  source "bashrc.erb"
end


directory "#{node["gitolite"]["directory"]}/.ssh" do
  owner node["gitolite"]["user"]
  group node["gitolite"]["user"]
  mode  0700
  action :create
end


bash "generate-ssh-key-for-gitolite-user" do
  user  node["gitolite"]["user"]
  group node["gitolite"]["user"]
  code <<-EOF
    ssh-keygen -t rsa -N "" -f #{node["gitolite"]["directory"]}/.ssh/id_rsa
  EOF
  not_if { ::File.exists?("#{node["gitolite"]["directory"]}/.ssh/id_rsa") }
end


bash "initialize-gitolite-directory" do
  cwd  node["gitolite"]["directory"]
  code <<-EOF
    cp #{node["gitolite"]["directory"]}/.ssh/id_rsa.pub /tmp/#{node["gitolite"]["user"]}.pub
    su -c 'gl-setup /tmp/#{node["gitolite"]["user"]}.pub' - #{node["gitolite"]["user"]}
  EOF
  not_if { ::File.exists?("#{node["gitolite"]["directory"]}/.gitolite.rc") }
end


template "#{node["gitolite"]["directory"]}/git_ssh_wrapper.sh" do
  action :create
  mode   0700
  owner  node["gitolite"]["user"]
  group  node["gitolite"]["user"]
  source "git_ssh_wrapper.sh.erb"
  variables({ :priv_key => "#{node["gitolite"]["directory"]}/.ssh/id_rsa" })
end
