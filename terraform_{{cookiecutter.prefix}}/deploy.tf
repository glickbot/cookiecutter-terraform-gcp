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

resource "google_cloudbuild_trigger" "terraform_repo_trigger" {
  project = module.project-tools.project_id
  ignored_files = ["Dockerfile", "cloudbuild.yaml", "*.md"]
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.terraform_repo.name
  }
  build {
    step {
      name = "gcr.io/cloud-builders/gsutil"
      args = ["cp", "${module.gcs_buckets.urls["sakeys"]}/credentials.enc", "/workspace/credentials.enc"]
    }
    step {
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "kms",
        "decrypt",
        "--ciphertext-file=/workspace/credentials.enc",
        "--plaintext-file=/workspace/credentials.json",
        "--keyring=${google_kms_key_ring.tools_keyring.id}",
        "--key=${google_kms_crypto_key.tf_executor_key.id}",
        "--location=${var.kms_keyring_location}",
      ]
    }
    step {
      name = "gcr.io/${module.project-tools.project_id}/terraform"
      args = ["init", "-input=false"]
      id   = "init-terraform"
      env  = ["GOOGLE_APPLICATION_CREDENTIALS=/workspace/credentials.json"]
    }
    step {
      name     = "gcr.io/${module.project-tools.project_id}/terraform"
      args     = ["apply", "-input=false", "-auto-approve"]
      wait_for = ["init-terraform"]
      id       = "terraform-apply"
      env      = ["GOOGLE_APPLICATION_CREDENTIALS=/workspace/credentials.json"]
    }
  }
}

resource "google_cloudbuild_trigger" "terraform_docker_repo_trigger" {
  project = module.project-tools.project_id
  included_files = ["Dockerfile", "cloudbuild.yaml"]
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.terraform_repo.name
  }
  filename = "cloudbuild.yaml"
  provisioner "local-exec" {
    command = "gcloud builds submit . --config=cloudbuild.yaml --project=${module.project-tools.project_id}"
  }
}

resource "google_sourcerepo_repository" "terraform_repo" {
  name    = "terraform_${var.prefix}"
  project = module.project-tools.project_id
  provisioner "local-exec" {
    command = "bash configure_repo.sh ${google_sourcerepo_repository.terraform_repo.name} ${module.project-tools.project_id}"
  }
}

