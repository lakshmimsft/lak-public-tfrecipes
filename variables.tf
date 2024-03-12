variable "password" {
  description = "The password for the PostgreSQL database"
  type        = string
}

variable "context" {
  description = "This variable contains Radius recipe context."

  type = any
}
