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
# Turn on swap to spped things up.
###########################################################

# Setup 4GB of swap.
if [ `sudo swapon -s | wc -l` -eq 1 ];
then
    dd if=/dev/zero of=/swapfile bs=512M count=8
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
fi
