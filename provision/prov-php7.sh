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

apt-get install python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get update

apt-get remove php5-common -y
apt-get purge php5-common -y

apt-get install php7.0

# PHP packages.
apt-get install -y ${PHP7_PACKAGES}

if [ "${PHP7_WEB_SERVER}" == "apache" ]; then
	# Turn off Nginx if enabled.
	service nginx stop
	update-rc.d nginx disable

	# Provision Apache for PHP5.
	${PROVISION_SH_DIR}/prov-php7-apache.sh

	# Enable and restart Apache.
	update-rc.d apache2 enable
	service apache2 restart

elif [ "${PHP7_WEB_SERVER}" == "nginx" ]; then
	# Turn off Apache if enabled.
	service apache2 stop
	update-rc.d apache2 disable

	# Install PHP5 FPM.
	${PROVISION_SH_DIR}/prov-php7-nginx.sh

	update-rc.d nginx enable
	service nginx restart

elif [ "${PHP5_WEB_SERVER}" == "" ]; then
	echo "No web server for PHP7 chosen."

else
	echo "Unknown web server name."
	exit 1
fi

# Install composer.
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
