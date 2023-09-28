resource "shoreline_notebook" "generic_title_host_network_receive_errors" {
  name       = "generic_title_host_network_receive_errors"
  data       = file("${path.module}/data/generic_title_host_network_receive_errors.json")
  depends_on = [shoreline_action.invoke_net_traffic_errors,shoreline_action.invoke_network_trace_and_block]
}

resource "shoreline_file" "net_traffic_errors" {
  name             = "net_traffic_errors"
  input_file       = "${path.module}/data/net_traffic_errors.sh"
  md5              = filemd5("${path.module}/data/net_traffic_errors.sh")
  description      = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  destination_path = "/agent/scripts/net_traffic_errors.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "network_trace_and_block" {
  name             = "network_trace_and_block"
  input_file       = "${path.module}/data/network_trace_and_block.sh"
  md5              = filemd5("${path.module}/data/network_trace_and_block.sh")
  description      = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  destination_path = "/agent/scripts/network_trace_and_block.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_net_traffic_errors" {
  name        = "invoke_net_traffic_errors"
  description = "Network congestion: Heavy network traffic or network congestion can cause Host Network Receive Errors."
  command     = "`chmod +x /agent/scripts/net_traffic_errors.sh && /agent/scripts/net_traffic_errors.sh`"
  params      = ["INTERFACE_NAME"]
  file_deps   = ["net_traffic_errors"]
  enabled     = true
  depends_on  = [shoreline_file.net_traffic_errors]
}

resource "shoreline_action" "invoke_network_trace_and_block" {
  name        = "invoke_network_trace_and_block"
  description = "Perform a network trace or packet capture to identify any malicious or abnormal network traffic that may be causing the receive errors. Block or quarantine the offending traffic as necessary."
  command     = "`chmod +x /agent/scripts/network_trace_and_block.sh && /agent/scripts/network_trace_and_block.sh`"
  params      = ["OUTPUT_FILE","OFFENDING_IP_ADDRESS","INTERFACE_NAME"]
  file_deps   = ["network_trace_and_block"]
  enabled     = true
  depends_on  = [shoreline_file.network_trace_and_block]
}

