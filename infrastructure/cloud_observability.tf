resource "google_monitoring_dashboard" "Carbon_Intensity_Generation_Mix" {
  dashboard_json = file("./json/Carbon_Intensity_Generation_Mix.json")
}

resource "google_monitoring_dashboard" "trivy_operator" {
  dashboard_json = file("./json/trivy_operator_dash.json")
}

resource "google_monitoring_dashboard" "trivy_operator_vuln" {
  dashboard_json = file("./json/trivy_operator_vuln.json")
}

resource "google_monitoring_dashboard" "trivy_workload_vuln" {
  dashboard_json = file("./json/trivy_workload_vuln.json")
}
