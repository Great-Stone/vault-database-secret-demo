terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create Network
resource "docker_network" "local" {
  name = "docker-net"
}

# Pulls the image
resource "docker_image" "mysql" {
  name = "mysql:latest"
}

# Create a container
resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "vault-dbsecret-mysql"

  networks_advanced {
    name = docker_network.local.name
  }

  env = [
    "MYSQL_ROOT_USERNAME=root",
    "MYSQL_ROOT_PASSWORD=password"
  ]

  ports {
    internal = "3306"
    external = "3306"
  }
}

# Pulls the image
resource "docker_image" "vault" {
  name = "vault:latest"
}

# Create a container
resource "docker_container" "vault" {
  image = docker_image.vault.image_id
  name  = "vault-dev"

  networks_advanced {
    name = docker_network.local.name
  }

  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=root",
    "VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200"
  ]

  ports {
    internal = "8200"
    external = "8200"
  }
}