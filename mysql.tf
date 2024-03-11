provider "mysql" {
  endpoint = "my-database.example.com:3306"
  username = "app-user"
  password = "app-password"
}

resource "mysql_database" "app_db" {
  name = "my_app_db"
}

resource "mysql_user" "app_user" {
  user     = "app_user"
  host     = "%"
  plaintext_password = "user-password"
}

resource "mysql_grant" "app_user_grant" {
  user       = mysql_user.app_user.user
  host       = mysql_user.app_user.host
  database   = mysql_database.app_db.name
  privileges = ["SELECT", "UPDATE", "INSERT", "DELETE"]
}
