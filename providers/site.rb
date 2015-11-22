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

  cert_bag = begin
              Chef::EncryptedDataBagItem.load('certificates', new_resource.name)
            rescue
              nil
            end

  if cert_bag
    cert_path = "/etc/nginx/ssl/#{new_resource.name}.crt"
    key_path = "/etc/nginx/ssl/#{new_resource.name}.key"

    file cert_path do
      owner   node[:np_web][:user]
      group   node[:np_web][:group]
      mode    '0644'
      content cert_bag['cert']
    end

    file key_path do
      owner     node[:np_web][:user]
      group     node[:np_web][:group]
      mode      '0640'
      content   cert_bag['key']
      sensitive true
    end
  else
    cert_path = nil
    key_path = nil
  end

  nginx_vhost new_resource.name do
    hostname "#{new_resource.name} www.#{new_resource.name}"
    port 80
    upstream false
    root_path ::File.join(site_dir, 'root')
    log_dir ::File.join(site_dir, 'logs')

    ssl_cert  cert_path
    ssl_key   key_path
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
