resource "google_sql_database" "sca_db" {
  name     = "sca_db"
  instance = google_sql_database_instance.sca_newdabatase.name
}
resource "google_sql_database_instance" "sca_newdabatase" {
  name             = "main-sqldb"
  database_version = "MYSQL_5_6"
  depends_on       = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = 10  # 10 GB is the smallest disk size
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.self_link
    }
  }
}
resource "google_sql_user" "db_user" {
  name     = "Iyanu"
  instance = google_sql_database_instance.sca_newdabatase.name
  password = "Iyanuoluwa@27"
  
}