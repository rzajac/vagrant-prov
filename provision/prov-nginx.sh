#!/usr/bin/env bash

# Copyright 2016 Rafal Zajac <rzajac@gmail.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This file is maintained at http://github.com/rzajac/vagrant-prov

# Import shared resources.
source /vagrant/Vagrantconf

###########################################################
# No need to edit below this line.
###########################################################

# Install packages.
apt-get install -y nginx

# https://coderwall.com/p/ztskha
sed -i "s/sendfile on;/sendfile off;/" /etc/nginx/nginx.conf

# By default stop and disable Nginx.
service nginx stop
update-rc.d nginx disable

# Some helpful scripts.
(
	rm -rf /tmp/nginx_ensite
	cd /tmp
	git clone https://github.com/perusio/nginx_ensite.git
	cd nginx_ensite
	make install
)

# Disable default site.
nginx_dissite default
