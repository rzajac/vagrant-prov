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

# Stop nginx.
service nginx stop
update-rc.d nginx disable

# Install Apache.
apt-get install -y apache2

# Get rid of warning: Could not reliably determine the server's fully qualified domain name.
echo "ServerName guest:80" >> /etc/apache2/apache2.conf

# Remove default website.
a2dissite 000-default

# Enable needed modules.
a2enmod ${APACHE_MODULES}

# Stop apache by default.
service apache2 stop
update-rc.d apache2 disable
