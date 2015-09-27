if defined?(ChefSpec)
  ChefSpec.define_matcher :np_web_site

  def create_np_web_site(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:np_web_site, :create, resource_name)
  end

  def delete_np_web_site(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:np_web_site, :delete, resource_name)
  end
end
