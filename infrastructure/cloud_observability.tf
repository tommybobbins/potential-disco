resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = jsonencode(file("./json/Carbon_Intensity_Generation_Mix.json"))
}
