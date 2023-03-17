resource "google_service_account" "sa" {
  account_id   = lower(var.sa_account_id)
  display_name = var.sa_display_name
  description  = var.sa_description
}

# resource "google_project_iam_member" "editor" {
#   member = "serviceAccount:${google_service_account.sa.email}"
#   role   = "roles/editor"
# }