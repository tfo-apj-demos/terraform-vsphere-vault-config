path "sys/events/subscribe/*" {
    capabilities = ["read"]
}
 
path "secrets/dev" {
  capabilities = ["list", "subscribe"]
  subscribe_event_types = ["*"]
}