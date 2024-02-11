resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "nginx"

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.private_network.name
  }
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }

  }
}

provider "docker" {}