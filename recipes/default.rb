#
# Cookbook Name:: np-web
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package 'gpg'
include_recipe 'nginx'

directory node[:np_web][:base_dir] do
  user  'root'
  group 'www-data'
  mode  '0775'
end

directory ::File.join(node['nginx']['dir'], 'ssl') do
  owner node[:np_web][:user]
  group node[:np_web][:group]
  mode  '0750'
end

# Drop the default site index.html
default_root = ::File.join(node[:np_web][:base_dir], 'default')
directory default_root do
  owner node[:np_web][:user]
  group node[:np_web][:group]
  mode  '0755'
end

cookbook_file ::File.join(default_root, 'index.html') do
  source  'default-index.html'
  owner   node[:np_web][:user]
  group   node[:np_web][:group]
  mode    '0755'
end

# Drop SSL cert and key for default website
cert_bag = Chef::EncryptedDataBagItem.load('certificates', 'nginx-default')

file ::File.join(node['nginx']['dir'], 'ssl/default.crt') do
  owner   node[:np_web][:user]
  group   node[:np_web][:group]
  mode    '0644'
  content cert_bag['cert']
end

file ::File.join(node['nginx']['dir'], 'ssl/default.key') do
  owner     node[:np_web][:user]
  group     node[:np_web][:group]
  mode      '0640'
  content   cert_bag['key']
  sensitive true
end

template ::File.join(node['nginx']['dir'], 'sites-available/default-site') do
  source  'default-site.erb'
  owner   node[:np_web][:user]
  group   node[:np_web][:group]
  mode    '0640'
end

link ::File.join(node['nginx']['dir'], 'sites-enabled/default-site') do
  to ::File.join(node['nginx']['dir'], 'sites-available/default-site')
end
