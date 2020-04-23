#!/bin/bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

# This code is a prototype and not engineered for production use.
# Error handling is incomplete or inappropriate for usage beyond
# a development sample.

set -e

url=https://releases.hashicorp.com

script_dir=$PWD

if [[ $EUID -ne 0 ]]; then
    mkdir -p $HOME/bin && pushd $HOME/bin > /dev/null
else
    mkdir -p /tmp/terraform && pushd /tmp/terraform > /dev/null
fi

if ls -1 $script_dir/terraform_*$1*.zip > /dev/null 2>&1; then
    unzip -n $(ls -1 $script_dir/terraform_*$1*.zip|head -1) > /dev/null
else
    latest_loc=$(curl -s $url/terraform/|grep -Eo "\\/terraform[^\\/]*\\/$1[^\\/]*\\/"|head -1)
    ver=$(echo $latest_loc|cut -d '/' -f 3)
    curl -s -O $url$latest_loc"terraform_"$ver"_linux_amd64.zip"
    unzip -n "terraform_"$ver"_linux_amd64.zip" > /dev/null
    rm -f "terraform_"$ver"_linux_amd64.zip"
fi

chmod 775 terraform

popd > /dev/null

if [[ $EUID -ne 0 ]]; then
    export PATH="$HOME/bin:$PATH"
else
    mv /tmp/terraform/terraform /usr/bin
    rm -r -f /tmp/terraform
fi