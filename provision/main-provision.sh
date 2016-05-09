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

###########################################################
# Edit Vagrantconf before provisioning.
###########################################################

# Import shared resources.
source /vagrant/Vagrantconf

###########################################################
# No need to edit below this line.
###########################################################

# Make it non interactive installation.
export DEBIAN_FRONTEND=noninteractive

# Configure swap.
${PROVISION_SH_DIR}/core-swap.sh 

# Configure environment, install most important software.
${PROVISION_SH_DIR}/core-core.sh

# Provision enabled.

if [ "${APACHE_ENABLE}" == "yes" ]; then
    ${PROVISION_SH_DIR}/prov-apache.sh
fi

if [ "${NGINX_ENABLE}" == "yes" ]; then
    ${PROVISION_SH_DIR}/prov-nginx.sh
fi

if [ "${PHP5_ENABLE}" == "yes" ]; then
    ${PROVISION_SH_DIR}/prov-php5.sh
fi

if [ "${MYSQL_ENABLE}" == "yes" ]; then
    ${PROVISION_SH_DIR}/prov-mysql.sh
fi

if [ "${MEMCACHED_ENABLE}" == "yes" ]; then
    ${PROVISION_SH_DIR}/prov-memcached.sh
fi

