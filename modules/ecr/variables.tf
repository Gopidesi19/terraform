
variable "repository_name" {
  description = "Names of ECR repositories to create"
  type        = set(string)

  default = [
    "vote",
    "result",
    "worker"
  ]
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Scan images when they are pushed"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of tagged images to retain"
  type        = number
  default     = 10
}