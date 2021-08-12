# np-web

[![Tests](https://github.com/nickpegg/cookbook-np-web/actions/workflows/tests.yml/badge.svg)](https://github.com/nickpegg/cookbook-np-web/actions/workflows/tests.yml)

Sets up nginx and provides a `np_web_site` resource to set up all the base
directories (web root, logs, etc.).

The np-web::static_sites does everything necessary to set up an Array of static
sites as defined in the `node['np-web']['static_sites']` attribute.

## Personal Cookbook Notice
This is a personal cookbook and I haven't really taken the care to generalize
it. It's public in hopes that maybe it's of use to someone, either directly
with its content or seeing how I do things with Chef.

## Testing
It's assumed that you have chefdk installed.

```bash
chef exec rake
chef exec kitchen test
```
