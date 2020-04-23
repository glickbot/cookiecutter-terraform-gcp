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

resource "local_file" "config_tf" {
  content = <<-EOT
    provider "google" {
        version = "~> 3.18"
        project = "${module.project-tools.project_id}"
        region = "${var.region}"
        zone   = "${var.zone}"
    }
    provider "google-beta" {
        version = "~> 3.18"
    }
    provider "local" {
        version = "~> 1.4"
    }
    provider "template" {
        version = "~> 2.1"
    }



    terraform {
        backend "gcs" {
            bucket = "${module.gcs_buckets.name}"
            prefix = "terraform/${var.prefix}"
        }
    }

    data "google_client_config" "current" {}

EOT


  filename = "${path.module}/config.tf"
}

