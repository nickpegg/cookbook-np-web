def whyrun_supported?
  true
end

action :create do
  directory site_dir do
    owner node[:np_web][:user]
    group node[:np_web][:group]
    mode '0755'
    recursive true
  end

  directory ::File.join(site_dir, 'root') do
    owner node[:np_web][:user]
    group node[:np_web][:group]
    mode '0755'
  end

  directory ::File.join(site_dir, 'logs') do
    owner node[:np_web][:user]
    group node[:np_web][:group]
    mode '0750'
  end

  nginx_vhost new_resource.name do
    hostname new_resource.name
    port 80
    upstream false
    root_path ::File.join(site_dir, 'root')
    log_dir ::File.join(site_dir, 'logs')
  end
end

action :delete do
  directory site_dir do
    action :delete
  end

  nginx_vhost site do
    action :remove
  end
end

def site_dir
  @site_dir ||= new_resource.path || ::File.join(node[:np_web][:base_dir], new_resource.name)
end
