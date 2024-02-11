resource "docker_image" "registry" {
  name = "registry:2"
}

resource "docker_container" "registry" {
  name  = "registry2"
  image = docker_image.registry.latest

    # ports {
    #     internal = 5000
    #     external = 5050
    # }

  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_network" "private_network" {
  name = "my_network"
}