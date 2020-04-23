# cookiecutter-terraform-gcp
cookiecutter template for a new GCP project, repository and executing terraform via cloud build

Theses terraform scripts bootstrap project/accounts/repo/trigger/cloud-build
After running, git pushes should trigger cloud build to execute terraform.

# Instructions

Install cookiecutter (https://github.com/cookiecutter/cookiecutter)

    cookiecutter https://github.com/glickbot/cookiecutter-terraform-gcp
    cd terraform_(your prefix)
    git init && git add . && git commit -a
    terraform init
    terraform apply
    terraform init #answer yes to move state file to new GCS backend bucket
    terraform plan #make sure no changes are needed

# Usage

At this point you should be able to add some terraform to main.tf, commit & push, and a trigger will execute terraform in a cloud build instance.

# Example

Add the following to main.tf

```
module "main_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 1.5"
  project_id = module.project-tools.project_id
  names      = ["new_bucket"]
  prefix     = var.prefix
  location   = var.location
}
```

    git commit -a
    git push

View build in cloud builder, then verify bucket.
