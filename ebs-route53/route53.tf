# resource "aws_route53_record" "www3" {
#   zone_id = "Z32OHGRMBVZ9LR"
#   name    = "www3.acirrustech.com"
#   type    = "A"
#   ttl     = "30"
#   records = ["${aws_instance.web.public_ip}"]
# }