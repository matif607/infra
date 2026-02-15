variable "developer_names" {
  type = map(string)
}

variable "user_namespaces" {
  type = list(string)
}

variable "permanent_admin_users" {
  type = list(string)
}

variable "permanent_admin_roles" {
  type = list(string)
}