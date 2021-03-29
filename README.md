# Setup

## Pre-req

- Google Cloud SDK (install from https://cloud.google.com/sdk/docs/install then run `gcloud init`)
- Terraform

# References

- https://codelabs.developers.google.com/codelabs/cloud-builder-gke-continuous-deploy#1
- https://learn.hashicorp.com/tutorials/terraform/gke?in=terraform/kubernetes

# Authentication

TODO - set up to use service account impersonation

## Authenticate using default login

```bash
gcloud auth application-default login
```


# Manual glcoud steps

```bash
gcloud services enable container.googleapis.com     containerregistry.googleapis.com     cloudbuild.googleapis.com     sourcerepo.googleapis.com
```

TODO confirm when the cloudbuild (not) service account was created
```bash
export PROJECT_NUMBER="$(gcloud projects describe $(gcloud config get-value core/project -q) --format='get(projectNumber)')"
export PROJECT=$(gcloud info --format='value(config.project)')
gcloud projects add-iam-policy-binding ${PROJECT} --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com     --role=roles/container.developer
  ```