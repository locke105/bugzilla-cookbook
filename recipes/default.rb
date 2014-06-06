# vim: set ts=2 sw=2 expandtab :

#
# Cookbook Name:: bugzilla
# Recipe:: default
#
# Copyright (C) 2013 Mathew Odden
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
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
%w(DateTime DateTime::TimeZone Template Email::Send Email::MIME List::MoreUtils Math::Random::ISAAC).each do |mod|
  cpan_module mod
end

# install apache
include_recipe 'apache2'
include_recipe 'apache2::mod_cgi'

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

# build database
include_recipe 'bugzilla::database'

template "/usr/local/#{base_name}/answers.pl" do
  source 'answers.pl.erb'
  notifies :run, 'bash[checksetup.pl]', :immediately
end

# update the localconfig when answers.pl has updates
bash 'checksetup.pl' do
  cwd "/usr/local/#{base_name}"
  code <<-EOH
    ./checksetup.pl answers.pl --verbose
  EOH
  action :nothing
end

# disable default site
apache_site 'default' do
  enable false
end

# setup the apache site
web_app 'bugzilla' do
  server_name node.hostname
  server_aliases [node.fqdn]
  docroot '/var/www/bugzilla'
  directory_options '+ExecCGI +FollowSymLinks'
  directory_index 'index.cgi index.html'
  allow_override 'Limit FileInfo Indexes Options'
end
