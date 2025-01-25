resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = file("./json/Carbon_Intensity_Generation_Mix.json")
}
