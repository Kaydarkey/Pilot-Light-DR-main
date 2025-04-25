resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.alternative_names
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_name
  ]
}
