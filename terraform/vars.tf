variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "sub_project_id" {
  description = "ID to prefix/suffix on various names to identity them as part of this test project (within the single sandbox project)"
  default     = "gke-test"
}
