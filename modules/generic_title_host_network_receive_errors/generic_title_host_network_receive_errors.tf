resource "shoreline_notebook" "generic_title_host_network_receive_errors" {
  name       = "generic_title_host_network_receive_errors"
  data       = file("${path.module}/data/generic_title_host_network_receive_errors.json")
  depends_on = [shoreline_action.invoke_network_diagnosis,shoreline_action.invoke_network_capture_and_block]
}

resource "shoreline_file" "network_diagnosis" {
  name             = "network_diagnosis"
  input_file       = "${path.module}/data/network_diagnosis.sh"
  md5              = filemd5("${path.module}/data/network_diagnosis.sh")
  description      = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  destination_path = "/agent/scripts/network_diagnosis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "network_capture_and_block" {
  name             = "network_capture_and_block"
  input_file       = "${path.module}/data/network_capture_and_block.sh"
  md5              = filemd5("${path.module}/data/network_capture_and_block.sh")
  description      = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  destination_path = "/agent/scripts/network_capture_and_block.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_network_diagnosis" {
  name        = "invoke_network_diagnosis"
  description = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  command     = "`chmod +x /agent/scripts/network_diagnosis.sh && /agent/scripts/network_diagnosis.sh`"
  params      = ["INTERFACE_NAME"]
  file_deps   = ["network_diagnosis"]
  enabled     = true
  depends_on  = [shoreline_file.network_diagnosis]
}

resource "shoreline_action" "invoke_network_capture_and_block" {
  name        = "invoke_network_capture_and_block"
  description = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  command     = "`chmod +x /agent/scripts/network_capture_and_block.sh && /agent/scripts/network_capture_and_block.sh`"
  params      = ["OUTPUT_FILE","OFFENDING_IP_ADDRESS","INTERFACE_NAME"]
  file_deps   = ["network_capture_and_block"]
  enabled     = true
  depends_on  = [shoreline_file.network_capture_and_block]
}

