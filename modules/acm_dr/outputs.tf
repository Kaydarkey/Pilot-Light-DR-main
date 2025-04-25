output "acm_cert_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}