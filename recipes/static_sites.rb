#
# Cookbook Name:: np-web
# Recipe:: static_sites
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Sets up all the static sites given by an attribute

node[:np_web][:static_sites].each do |site|
  np_web_site site
end
