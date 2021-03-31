resource "google_cloudbuild_trigger" "trigger-dev" {

  name = "Trigger-DEV"

  trigger_template {
    project_id  = "duncan-elliot-sandbox"
    branch_name = "[^(?!.*main)].*"
    repo_name   = "default"
    #dir         = "app"
  }

  substitutions = {
    _CLOUDSDK_COMPUTE_ZONE      = var.region
    _CLOUDSDK_CONTAINER_CLUSTER = google_container_cluster.primary.name
  }

  filename = "cloudbuild/cloudbuild-dev.yaml"
}

resource "google_cloudbuild_trigger" "trigger-canary" {

  name = "Trigger-CANARY"

  trigger_template {
    project_id  = "duncan-elliot-sandbox"
    branch_name = "main"
    repo_name   = "default"
    dir         = "app"
  }

  substitutions = {
    _CLOUDSDK_COMPUTE_ZONE      = var.region
    _CLOUDSDK_CONTAINER_CLUSTER = google_container_cluster.primary.name
  }

  filename = "cloudbuild/cloudbuild-canary.yaml"
}

resource "google_cloudbuild_trigger" "trigger-prod" {

  name = "Trigger-PROD"

  trigger_template {
    project_id = "duncan-elliot-sandbox"
    tag_name   = ".*"
    repo_name  = "default"
    dir        = "app"
  }

  substitutions = {
    _CLOUDSDK_COMPUTE_ZONE      = var.region
    _CLOUDSDK_CONTAINER_CLUSTER = google_container_cluster.primary.name
  }

  filename = "cloudbuild/cloudbuild-prod.yaml"
}
