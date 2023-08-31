variable "edge_application" {
  type        = any
  description = "Edge application parameters"
}

variable "origins" {
  type        = list(any)
  description = "List of origins"
}

variable "routes" {
  type        = list(any)
  description = "List of rules and cache settings"
}
