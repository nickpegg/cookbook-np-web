#
# Cookbook Name:: np-web
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'nginx'

directory node[:np_web][:base_dir] do
  user 'root'
  group 'www-data'
  mode '0775'
end
