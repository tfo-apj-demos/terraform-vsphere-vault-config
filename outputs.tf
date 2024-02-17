output "ca_chain_certificate" {
  value       = file("${path.module}/ca_cert_dir/ca_chain.pem")
  description = "The content of the CA certificate."
}