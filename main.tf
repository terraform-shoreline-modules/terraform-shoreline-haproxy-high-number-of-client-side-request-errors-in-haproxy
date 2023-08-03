terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_number_of_client_side_request_errors_with_haproxy" {
  source    = "./modules/high_number_of_client_side_request_errors_with_haproxy"

  providers = {
    shoreline = shoreline
  }
}