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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ $# -ne 2 ]; then
    echo "Please provide REPO_ID, PROJECT_ID"
    exit 1
fi

REPO_ID=$1
PROJECT_ID=$2
TMPDIR=/tmp/temp_repo

if [ -d TMPDIR ]; then
   rm -r -f $TMPDIR
fi

gcloud source repos clone $REPO_ID $TMPDIR --project=$PROJECT_ID

pushd $TMPDIR > /dev/null

git remote add source $DIR

git pull source master

git push --force

popd > /dev/null

rm -r -f $TMPDIR

if git remote | grep -E '^origin$' > /dev/null; then
  git remote remove origin
fi
git remote add origin $(gcloud source repos describe $REPO_ID --project=$PROJECT_ID --format=json|jq '.url' -r)
git fetch
git branch --set-upstream-to=origin/master master
