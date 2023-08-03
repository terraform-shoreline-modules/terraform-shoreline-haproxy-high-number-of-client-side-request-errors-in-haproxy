resource "shoreline_notebook" "high_number_of_client_side_request_errors_with_haproxy" {
  name       = "high_number_of_client_side_request_errors_with_haproxy"
  data       = file("${path.module}/data/high_number_of_client_side_request_errors_with_haproxy.json")
  depends_on = [shoreline_action.invoke_anomaly_check,shoreline_action.invoke_haproxy_maxconn_update]
}

resource "shoreline_file" "anomaly_check" {
  name             = "anomaly_check"
  input_file       = "${path.module}/data/anomaly_check.sh"
  md5              = filemd5("${path.module}/data/anomaly_check.sh")
  description      = "Security-related issues such as DDoS attacks or malicious traffic that cause anomalies in the error rate."
  destination_path = "/agent/scripts/anomaly_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "haproxy_maxconn_update" {
  name             = "haproxy_maxconn_update"
  input_file       = "${path.module}/data/haproxy_maxconn_update.sh"
  md5              = filemd5("${path.module}/data/haproxy_maxconn_update.sh")
  description      = "Updates the maximum connections ."
  destination_path = "/agent/scripts/haproxy_maxconn_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_anomaly_check" {
  name        = "invoke_anomaly_check"
  description = "Security-related issues such as DDoS attacks or malicious traffic that cause anomalies in the error rate."
  command     = "`chmod +x /agent/scripts/anomaly_check.sh && /agent/scripts/anomaly_check.sh`"
  params      = []
  file_deps   = ["anomaly_check"]
  enabled     = true
  depends_on  = [shoreline_file.anomaly_check]
}

resource "shoreline_action" "invoke_haproxy_maxconn_update" {
  name        = "invoke_haproxy_maxconn_update"
  description = "Updates the maximum connections ."
  command     = "`chmod +x /agent/scripts/haproxy_maxconn_update.sh && /agent/scripts/haproxy_maxconn_update.sh`"
  params      = ["HAPROXY_CFG","MAX_CONNECTIONS"]
  file_deps   = ["haproxy_maxconn_update"]
  enabled     = true
  depends_on  = [shoreline_file.haproxy_maxconn_update]
}

