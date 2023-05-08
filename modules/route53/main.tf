resource "aws_route53_zone" "zone" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.zone.id
  name    = var.route53_record_name
  type    = var.route53_record_type
  ttl     = var.route53_record_ttl
  records = var.route53_records
}
