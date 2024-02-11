# users have username and password
variable "users" {
  type = list(object({
    username = string
    password = string
  }))
  default = [
    {
      username = "user1"
      password = "pass1"
    },
    {
      username = "user2"
      password = "pass2"
    },
    {
      username = "user9"
      password = "pass9"
    }
  ]
}

# password is hashed
locals {
  user_map = { for user in var.users :
    user.username => bcrypt(user.password)
  }
}

# htpasswd file stores the users
locals {
  htpasswd = templatefile("${path.module}/htpasswd.tpl", { users : local.user_map })
}

output "htpasswd" {
  value = local.htpasswd
}