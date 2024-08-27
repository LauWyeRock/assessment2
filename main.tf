provider "google" {
  credentials = file("C:/Users/wyero/Downloads/zeta-student-381111-6db8701d2360.json")
  project     = "zeta-student-381111"
  region      = "us-central1"
}

resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-functions"
  location = "US"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "lambda_function.zip"
}

resource "google_cloudfunctions_function" "users_function" {
  name        = "GetUsersFunction"
  description = "Returns a list of users from an API"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  entry_point           = "lambda_handler"

  trigger_http = true

  environment_variables = {
    "API_URL" = "https://jsonplaceholder.typicode.com/users"
  }
}
