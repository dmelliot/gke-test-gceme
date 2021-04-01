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

# `kubectl` control

## Set up `kubectl` context

Get details of cluster

```bash
gcloud container clusters describe <cluster name> --region <region>
```

Set config in kube config (i.e. `~/.kube/config`)
```bash
gcloud container clusters get-credentials
```


## Manual deploy with `kubectl`


```
kubectl create ns production
kubectl apply -f kubernetes/deployments/prod -n production
kubectl apply -f kubernetes/deployments/canary -n production
kubectl apply -f kubernetes/services -n production
```

## Other examples using `kubectl`

Scale up/down the front end replicas
```bash
kubectl -n production scale --replicas=2 deployments/gceme-frontend-production
```

Run interactive bash shell in the first container found in the first pod of the specified service.
```bash
kubectl -n production exec svc/gceme-frontend -it -- bash
```

The backend pods are fronted by a `ClusterIP` service (no `type` is specified in `backend.yaml` so it defaults to `ClusterIP`).  This service balances/proxies requests to the endpoints.

```bash
kubectl -n production get service gceme-backend --output=yaml
```

If the service has a selector specified (`backend.yaml` does) then an `Endpoints` object of the same name is created with the service.
The controller for the `Service` selector continuously scans for Pods that match its selector, and then POSTs any updates to an Endpoint object.
```bash
kubectl -n production get endpoints gceme-backend --output=yaml
```