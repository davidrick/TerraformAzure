variable "location" {
  type        = string
  description = "This defines the location"
}

variable "number_of_subnets" {
  type        = number
  description = "This defines the number of subnets"
  default     = 2
  validation {
    condition     = var.number_of_subnets < 5
    error_message = "The number of subnets must be less than 5"
  }
}

variable "resource_group_name" {
  type        = string
  description = "This defines the resource group name"
}


