terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "2.14.0"
        }
    }
}
provider "docker" {
    host = "unix:///var/run/docker.sock"
}

resource "docker_image" "mysql" {
    name = "mysql"
    build {
        path = "mysql"
    }
}

resource "docker_image" "php" {
    name = "php"
    build {
        path = "php"
    }
}

