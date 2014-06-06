# vim: set ts=2 sw=2 expandtab :

#
# Cookbook Name:: bugzilla
# Recipe:: database
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

# mysql only right now
conn_info = {:host => node.bugzilla.db_host,
	           :username => 'root',
	           :password => node.mysql.server_root_password}

db_name = node.bugzilla.db_name

mysql_database db_name do
  connection conn_info
  action :create
end

# mysql GRANTs create the user as well
mysql_database_user node.bugzilla.db_user do
  connection conn_info
  database_name db_name
  password node.bugzilla.db_pass
  privileges [ :all ]
  action :grant
end

# make permissions changes active in MySQL
mysql_database "flush_privileges" do
  connection conn_info
  action :query
  sql 'FLUSH PRIVILEGES'
end
