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

# Provision Apache.
${PROVISION_SH_DIR}/prov-apache.sh

# Set project directories.
if [ "${PROJECT_INDEX_DIR}" != "" ]; then
    PROJECT_INDEX_DIR="${PROJECT_DIR_NAME}/${PROJECT_INDEX_DIR}"
else
    PROJECT_INDEX_DIR="${PROJECT_DIR_NAME}"
fi

# Create directory for project.
mkdir -p /usr/local/var/www/${PROJECT_DIR_NAME}

# Install PHP5 Apache module and provision PHP5 apache application.
apt-get -y install libapache2-mod-php5

cat > /etc/apache2/sites-available/${PROJECT_DEV_DOMAIN}.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /usr/local/var/www/${PROJECT_INDEX_DIR}
    ServerName ${PROJECT_DEV_DOMAIN}

    <Directory /usr/local/var/www/${PROJECT_INDEX_DIR}>
        Options Indexes FollowSymLinks Includes ExecCGI
        Require all granted
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${PROJECT_DEV_DOMAIN}.error.log
    CustomLog \${APACHE_LOG_DIR}/${PROJECT_DEV_DOMAIN}.access.log combined
</VirtualHost>
EOF

# Enable project site.
a2ensite ${PROJECT_DEV_DOMAIN}

# Add development domain to hosts file.
echo "127.0.1.1 ${PROJECT_DEV_DOMAIN}" >> /etc/hosts
