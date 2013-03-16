#
# Cookbook Name:: gitolite
# Recipe:: repos
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

include_recipe "gitolite::install"

bash "clean-up-gitolite-config" do
  cwd  "/tmp"
  code <<-EOF
    rm -r /tmp/gitolite-admin
  EOF
  only_if { ::File.exists?("/tmp/gitolite-admin") }
end


bash "clone-gitolite-config" do
  cwd  "/tmp"
  code <<-EOF
    GIT_SSH=#{node["gitolite"]["directory"]}/git_ssh_wrapper.sh \
    git clone #{node["gitolite"]["user"]}@localhost:gitolite-admin.git
  EOF
  not_if { ::File.exists?("/tmp/gitolite-admin") }
end


template "/tmp/gitolite-admin/conf/gitolite.conf" do
  action :create
  owner  node["gitolite"]["user"]
  group  node["gitolite"]["user"]
  source "gitolite.conf.erb"
  variables({
    :repos => data_bag("gitolite").map { |name| data_bag_item("gitolite", name) }
  })
end


data_bag("users").each do |user_id|
  user = data_bag_item("users", user_id)
  bash "copy-public-key-for-#{user["id"]}" do
    environment("GIT_PUB_KEY" => user["pub_key"])
    code <<-EOF
      echo $GIT_PUB_KEY > /tmp/gitolite-admin/keydir/#{user["id"]}.pub
      chown #{node["gitolite"]["user"]}:#{node["gitolite"]["user"]} -R /tmp/gitolite-admin/
    EOF
  end
end


bash "push-gitolite-config" do
  cwd  "/tmp/gitolite-admin"
  code <<-EOF
    git config --global user.name "#{node["gitolite"]["user"]}"
    git config --global user.email #{node["gitolite"]["user"]}@#{node["hostname"]}
    git add . && git commit -m "CHEF: Updating users and repos"
    GIT_SSH=#{node["gitolite"]["directory"]}/git_ssh_wrapper.sh \
    git push origin master
  EOF
  not_if "git diff-index --quiet HEAD --"
end
