terraform {
  cloud {
    organization = "my-homelab"
    workspaces {
      name = "homelab-cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.25.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}

# Read secrets
data "sops_file" "cloudflare_secrets" {
  source_file = "cloudflare_secrets.sops.yaml"
}

# Obtain current home IP address
data "http" "ipv4" {
  url = "http://ipv4.icanhazip.com"
}

data "cloudflare_api_token_permission_groups" "all" {}

data "cloudflare_zones" "homelab" {
  filter {
    name = data.sops_file.cloudflare_secrets.data["cloudflare_domain_homelab"]
  }
}
