# vim: set ts=2 sw=2 expandtab :

#
# Cookbook Name:: bugzilla
# Attributes:: default
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
# under the License.#
#

default.bugzilla.db_host = 'localhost'
default.bugzilla.db_driver = 'mysql'
default.bugzilla.db_port = 3306
default.bugzilla.db_name = 'bugs'
default.bugzilla.db_user = 'bugzilla'
default.bugzilla.db_pass = 'supersecretsauce'

default.bugzilla.webservergroup = node.apache.group
default.bugzilla.urlbase = "http://#{node.fqdn}/"

default.bugzilla.smtp_server = 'localhost'
default.bugzilla.admin_email = 'default@example.com'
default.bugzilla.admin_password = 'bugcrusher9000'
default.bugzilla.admin_realname = 'Admin'
