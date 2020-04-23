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

module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 1.5"
  project_id = module.project-tools.project_id
  names      = ["toolstf", "sakeys"]
  prefix     = var.prefix
  location   = var.location
  versioning = {
    toolstf = true
    sakeys  = false
  }
  set_admin_roles = true
  admins = [
    module.service_account.iam_email,
    "serviceAccount:${module.project-tools.project_number}@cloudbuild.gserviceaccount.com",
  ]
}

module "project-tools" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 8.0"
  name                        = "${var.prefix}-tools"
  random_project_id           = true
  org_id                      = var.org_id
  billing_account             = var.billing_id
  default_service_account     = "keep"
  disable_dependent_services  = "false"
  disable_services_on_destroy = "false"
  domain                      = var.domain
  folder_id                   = google_folder.folder.name
  activate_apis = [
    "cloudbuild.googleapis.com",
    "storage-api.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "appengine.googleapis.com",
    "container.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudkms.googleapis.com",
    "serviceusage.googleapis.com",
  ]
  auto_create_network = true
}

resource "google_folder" "folder" {
  display_name = var.prefix
  parent       = "organizations/${var.org_id}"
}

