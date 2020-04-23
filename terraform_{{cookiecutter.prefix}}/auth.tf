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

module "service_account" {
  source             = "terraform-google-modules/service-accounts/google"
  version            = "~> 2.0"
  project_id         = module.project-tools.project_id
  prefix             = var.prefix
  names              = ["tools-tf-executor"]
  grant_billing_role = true
  grant_xpn_roles    = true
  org_id             = var.org_id
  generate_keys      = false
}

resource "google_organization_iam_member" "org_binding" {
  count  = length(var.sa_org_roles)
  org_id = var.org_id
  role   = var.sa_org_roles[count.index]
  member = module.service_account.iam_email
}

resource "google_folder_iam_member" "folder_binding" {
  count  = length(var.sa_folder_roles)
  folder = google_folder.folder.name
  role   = var.sa_folder_roles[count.index]
  member = module.service_account.iam_email
}

resource "null_resource" "upload_credentials" {
  triggers = {
    credentials_state = google_storage_bucket_object.credentials-state.name
  }
  provisioner "local-exec" {
    command = <<EOF
./upload_credentials.sh \
    ${module.service_account.email} \
    ${google_kms_key_ring.tools_keyring.id} \
    ${google_kms_crypto_key.tf_executor_key.id} \
    ${var.kms_keyring_location} \
    ${module.gcs_buckets.urls["sakeys"]}
EOF

  }
}

resource "google_storage_bucket_object" "credentials-state" {
  name    = "credentials.state"
  content = "credentials.state"
  bucket  = module.gcs_buckets.names["sakeys"]
}

resource "google_kms_key_ring" "tools_keyring" {
  project  = module.project-tools.project_id
  name     = "${var.prefix}_tools_keyring"
  location = var.kms_keyring_location
}

resource "google_kms_crypto_key" "tf_executor_key" {
  name     = "tf-executor-key"
  key_ring = google_kms_key_ring.tools_keyring.id
}

resource "google_project_iam_member" "builder_key_decrypter" {
  project = module.project-tools.project_id
  role    = "roles/cloudkms.cryptoKeyDecrypter"
  member  = "serviceAccount:${module.project-tools.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_kms_key_ring_iam_member" "builder_key_use" {
  key_ring_id = google_kms_key_ring.tools_keyring.id
  role        = "roles/cloudkms.cryptoKeyDecrypter"
  member      = "serviceAccount:${module.project-tools.project_number}@cloudbuild.gserviceaccount.com"
}

