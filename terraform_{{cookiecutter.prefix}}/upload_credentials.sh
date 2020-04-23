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

# upload_credentials.sh \
#    ${module.service_account.email}
#    ${google_kms_key_ring.tools_keyring.id}
#    ${google_kms_crypto_key.tf_executor_key.id}
#    ${var.kms_keyring_location}
#    ${module.gcs_buckets.urls["sakeys"]}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ $# -ne 5 ]; then
    echo "Please provide 5 args"
    exit 1
fi

set -e

gcloud iam service-accounts keys create credentials.json \
  --iam-account $1

gcloud kms encrypt \
  --ciphertext-file=$DIR/credentials.enc \
  --plaintext-file=$DIR/credentials.json \
  --keyring=$2 \
  --key=$3 \
  --location=$4

bash $DIR/wipe.sh $DIR/credentials.json

gsutil cp $DIR/credentials.enc $5

bash $DIR/wipe.sh $DIR/credentials.enc