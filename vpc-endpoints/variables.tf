variable "vpc_endpoints" {
  type = map(object({
    endpoints = map(any)
  }))
}

variable "vpc" {
  type = map(any)
}