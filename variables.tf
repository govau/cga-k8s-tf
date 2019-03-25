variable "name" {
  description = "Name of this environment, may be used for labels or to namespace created resources"
}

variable "cld_internal_zone_id" {
  description = "Internal DNS Zone ID in this environment (cld.internal.)"
}
