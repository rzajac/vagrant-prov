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

# Root password for MySQL.
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASS}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASS}"

# Install packages.
apt-get install -y mysql-server mysql-client

# Configure MySQL to bind to all addresses.
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Add users.
echo "CREATE USER '${MYSQL_APP_USER}'@'%' IDENTIFIED BY '${MYSQL_APP_PASS}'" | mysql -uroot -p${MYSQL_ROOT_PASS}

# Create databases.
echo "CREATE DATABASE ${MYSQL_APP_DB} DEFAULT CHARACTER SET utf8;" | mysql -uroot -p${MYSQL_ROOT_PASS}

# Grant privileges.
echo "GRANT ALL ON ${MYSQL_APP_DB}.* TO '${MYSQL_APP_USER}'@'%'" | mysql -uroot -p${MYSQL_ROOT_PASS}

# Allow root to login from anywhere
echo "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASS'" | mysql -uroot -p${MYSQL_ROOT_PASS}
echo "GRANT ALL ON *.* TO 'root'@'%'" | mysql -uroot -p${MYSQL_ROOT_PASS}
echo "flush privileges" | mysql -uroot -p${MYSQL_ROOT_PASS}

# Seed the database
if [ -f ${PROVISION_SH_DIR}/mysql-seed.sql ];
then
    mysql -uroot -p${MYSQL_ROOT_PASS} ${MYSQL_APP_DB} < ${PROVISION_SH_DIR}/mysql-seed.sql
fi

echo
echo
echo
echo "MySQL root password: ${MYSQL_ROOT_PASS}"
echo "MySQL database created: ${MYSQL_APP_DB}"
echo "MySQL user created: ${MYSQL_APP_USER} / ${MYSQL_APP_PASS}"
echo
echo
echo

# Final restarts.
service mysql restart
