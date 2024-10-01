terraform {
  backend "pg" {
    conn_str      = "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
    schema_name   = "terraform-k8s-2"
  }
}

