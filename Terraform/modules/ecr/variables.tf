variable "name" {
  type        = string
  description = "ecr repository name"
}

variable "is_scan_on_push" {
  type        = bool
  description = "default is true"
  default     = true
}