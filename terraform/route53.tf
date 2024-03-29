resource "aws_route53_zone" "domain" {
  name = "example.com"  
  comment = "Managed by Terraform"
}

resource "aws_route53_record" "elb_alias" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = elb-dns-name
    zone_id               = elb-zone-id
    evaluate_target_health = true
  }
}