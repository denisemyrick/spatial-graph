terraform {
  required_version = ">= 1.3.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# The provider creates the database in the LiveLabs reservation compartment.
# The default region matches the IAD LiveLabs reservation; override it when a
# reservation is created in another OCI region.
provider "oci" {
  region = local.oci_region
}

provider "oci" {
  alias  = "home"
  region = local.home_region
}
