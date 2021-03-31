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

## CloudBuild accessing the repo
It's easiest if we push the code to _Cloud Source_ (i.e. it makes it easier for _Cloud Build_ to access).  To set this up, add an SSH key via the menu in _Cloud Source_.  Alternatively, access to _GitHub_ can be setup by installing an app on _GitHub_ (more details TBD).

## Set up `kubectl` context

Get details of cluster

```bash
gcloud container clusters describe <cluster name> --region <region>
```

Set config in kube config (i.e. `~/.kube/config`)
```bash
gcloud container clusters get-credentials
```


# Manual deploy

TODO - put in make file or tf?
```
kubectl create ns production
kubectl apply -f kubernetes/deployments/prod -n production
kubectl apply -f kubernetes/deployments/canary -n production
kubectl apply -f kubernetes/services -n production
```
