provider "google" {
  version = "~> 3.18"
  region = "{{cookiecutter.region}}"
  zone   = "{{cookiecutter.zone}}"
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

