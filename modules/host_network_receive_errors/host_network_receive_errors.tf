resource "shoreline_notebook" "host_network_receive_errors" {
  name       = "host_network_receive_errors"
  data       = file("${path.module}/data/host_network_receive_errors.json")
  depends_on = [shoreline_action.invoke_network_diagnostic,shoreline_action.invoke_network_analysis]
}

resource "shoreline_file" "network_diagnostic" {
  name             = "network_diagnostic"
  input_file       = "${path.module}/data/network_diagnostic.sh"
  md5              = filemd5("${path.module}/data/network_diagnostic.sh")
  description      = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  destination_path = "/tmp/network_diagnostic.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "network_analysis" {
  name             = "network_analysis"
  input_file       = "${path.module}/data/network_analysis.sh"
  md5              = filemd5("${path.module}/data/network_analysis.sh")
  description      = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  destination_path = "/tmp/network_analysis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_network_diagnostic" {
  name        = "invoke_network_diagnostic"
  description = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  command     = "`chmod +x /tmp/network_diagnostic.sh && /tmp/network_diagnostic.sh`"
  params      = ["INTERFACE_NAME"]
  file_deps   = ["network_diagnostic"]
  enabled     = true
  depends_on  = [shoreline_file.network_diagnostic]
}

resource "shoreline_action" "invoke_network_analysis" {
  name        = "invoke_network_analysis"
  description = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  command     = "`chmod +x /tmp/network_analysis.sh && /tmp/network_analysis.sh`"
  params      = ["INTERFACE_NAME","OFFENDING_IP_ADDRESS","OUTPUT_FILE"]
  file_deps   = ["network_analysis"]
  enabled     = true
  depends_on  = [shoreline_file.network_analysis]
}

