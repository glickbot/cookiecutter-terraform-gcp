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

if [ $# -ne 1 ]; then
  echo "Usage wipe.sh <path/to/file>"
  echo "WARNING: Completely wipes the file!"
  exit 1
fi

file=$1
bytes=$(stat --printf="%s" $file)
dd if=/dev/urandom of=$file bs=$bytes count=1 conv=notrunc > /dev/null
rm -f $file
