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

resource "docker_container" "mysql" {
    name = "mysql"
    image = docker_image.mysql.latest
    env = [
        "MYSQL_ROOT_PASSWORD=12345"
    ]
}

resource "docker_container" "php" {
    name = "php"
    image = docker_image.php.latest
    ports {
        internal = 80
        external = 5435
    }
    mounts {
        type = "bind"
        target = "/var/www/html"
        source = "${path.cwd}/site"
    }
    env = [
        "MYSQL_HOST=${docker_container.mysql.ip_address}"
    ]
}

