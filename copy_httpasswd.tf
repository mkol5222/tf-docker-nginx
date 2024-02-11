
# need to copy htpasswd file to container, if changed
resource "null_resource" "htpasswd_copy" {
  triggers = {
    container_id = docker_container.nginx.id
    hash         = sha1(local.htpasswd)
  }

  provisioner "local-exec" {
    command = "docker cp ${local_file.htpasswd.filename} ${docker_container.nginx.name}:/tmp/htpasswd"
  }

  depends_on = [docker_container.nginx, local_file.htpasswd]
}

# render nginx config file
locals {
  nginxconf = templatefile("${path.module}/nginx-conf.tpl", { a = "a" })
}

# need to copy nginx config file to container, if changed
resource "null_resource" "nginxconf_copy" {
  triggers = {
    container_id = docker_container.nginx.id
    hash         = sha1(local.nginxconf)
  }

  provisioner "local-exec" {

    command = "docker cp ${local_file.nginxconf.filename} ${docker_container.nginx.name}:/etc/nginx/conf.d/default.conf"

  }

  depends_on = [docker_container.nginx]
}

# reload NGINX when confguration changes
resource "null_resource" "nginx_restart" {
  triggers = {
    container_id = docker_container.nginx.id
    hash         = sha1(local.nginxconf)
  }

  provisioner "local-exec" {
    command = "docker exec ${docker_container.nginx.name} nginx -s reload"
  }

  depends_on = [null_resource.nginxconf_copy]
}


resource "random_id" "htpasswd" {
  byte_length = 8
}

# need to store as file to copy to container
resource "local_file" "htpasswd" {
  content  = local.htpasswd
  filename = "/tmp/htpasswd-file-${random_id.htpasswd.hex}"

  provisioner "local-exec" {
    command = "cat ${self.filename}"
  }
}

resource "random_id" "nginxconf" {
  byte_length = 8
}

resource "local_file" "nginxconf" {
  content  = local.nginxconf
  filename = "/tmp/nginxconf-file-${random_id.nginxconf.hex}"

  provisioner "local-exec" {
    command = "cat ${self.filename}"
  }
}