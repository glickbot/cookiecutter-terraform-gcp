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
# limitations under the License.

prefix="{{cookiecutter.prefix}}"
org_id="{{cookiecutter.org_id}}"
billing_id="{{cookiecutter.billing_id}}"
domain="{{cookiecutter.domain}}"
region="{{cookiecutter.region}}"
zone="{{cookiecutter.zone}}"
location="{{cookiecutter.location}}"
kms_keyring_location="global"

sa_org_roles = {
    "0" = "roles/resourcemanager.organizationViewer",
    "1" = "roles/iam.organizationRoleViewer",
    "2" = "roles/orgpolicy.policyViewer",
}

sa_folder_roles = {
    "0" = "roles/owner",
    "1" = "roles/appengine.appAdmin",
    "2" = "roles/compute.networkAdmin",
    "3" = "roles/compute.xpnAdmin",
    "4" = "roles/resourcemanager.folderAdmin",
    "5" = "roles/compute.admin",
    "6" = "roles/orgpolicy.policyViewer",
    "7" = "roles/resourcemanager.projectCreator",
}
