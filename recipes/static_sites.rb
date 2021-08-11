#
# Copyright:: 2015-2021 Nick Pegg
# Cookbook:: np-web
# Recipe:: static_sites
#

# Sets up all the static sites given by an attribute

node['np_web']['static_sites'].each do |site|
  np_web_site site
end
