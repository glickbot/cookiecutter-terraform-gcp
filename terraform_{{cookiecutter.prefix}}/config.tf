provider "google" {
  region = "{{cookiecutter.region}}"
  zone   = "{{cookiecutter.zone}}"
}

provider "google-beta" {
}

provider "local" {
}

provider "template" {
}

