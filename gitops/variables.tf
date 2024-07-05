variable "project-name" {
  type        = string
  description = "The name of the project"
}

variable "project-description" {
  type        = string
  description = "The description of the project"
}

variable "github_access_token" {
  type        = string
  description = "The github token ( passed by ENV TF_VAR_github_access_token )"
}