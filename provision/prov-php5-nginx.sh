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

# Provision Nginx.
${PROVISION_SH_DIR}/prov-nginx.sh

# Set project directories.
if [ "${PROJECT_INDEX_DIR}" != "" ]; then
    PROJECT_INDEX_DIR="${PROJECT_DIR_NAME}/${PROJECT_INDEX_DIR}"
else
    PROJECT_INDEX_DIR="${PROJECT_DIR_NAME}"
fi

# Create directory for project.
mkdir -p /usr/local/var/www/${PROJECT_DIR_NAME}

# Install packages.
apt-get install -y php5-fpm

cat > /etc/nginx/sites-available/${PROJECT_DIR_NAME} <<EOF
server {
  listen   80;

  root /usr/local/var/www/$PROJECT_INDEX_DIR;
  index index.html index.htm index.php;

  server_name $PROJECT_DEV_DOMAIN;

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to index.html
    try_files \$uri \$uri/ /index.php?\$query_string;
  }

  error_page  405     =200 \$uri;

  # redirect server error pages to the static page /50x.html
  #
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }

  # pass the PHP scripts to FastCGI server listening on /tmp/php5-fpm.sock
  #
  location ~ \.php$ {
      try_files \$uri =404;
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      include /etc/nginx/fastcgi_params;
      fastcgi_pass unix:/var/run/php5-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
      fastcgi_intercept_errors on;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  #
  location ~ /\.ht {
    deny all;
  }
}
EOF

# Add development domain to hosts file.
echo "127.0.1.1 ${PROJECT_DEV_DOMAIN}" >> /etc/hosts

nginx_ensite myproject
