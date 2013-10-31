# vim: set ts=2 sw=2 expandtab :

#
# Cookbook Name:: bugzilla
# Recipe:: default
#
# Copyright (C) 2013 Matt Odden
# 
# All rights reserved - Do Not Redistribute
#

# need mysql client libs
include_recipe 'database::mysql'

# install mysql server
node.default.mysql.bind_address = '127.0.0.1'
include_recipe 'mysql::server'

# TODO(mrodden): install MTA
# include_recipe 'postfix'

# install perl (ughh...)
include_recipe 'perl'

# install apache
include_recipe 'apache'

directory '/usr/local/'

base_name = 'bugzilla-4.4.1'
remote_file "/tmp/#{base_name}.tar.gz" do
  source "http://ftp.mozilla.org/pub/mozilla.org/webtools/#{base_name}.tar.gz"
  notifies :run, 'bash[install_tarball]', :immediately
end

bash 'install_tarball' do
  cwd '/tmp'
  code <<-EOH
    tar -zxf #{base_name}.tar.gz -C /usr/local/
    ln -s /usr/local/#{base_name} /var/www/bugzilla
    chown -R www-data:www-data /var/www/bugzilla
  EOH
  action :nothing
end

