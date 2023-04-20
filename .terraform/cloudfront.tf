# Cloudfront distribution for main s3 site.
resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.www_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = aws_s3_bucket.www_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.www_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.https_cert.certificate_arn
    ssl_support_method  = "sni-only"
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths '/'"
  }

  tags = var.common_tags
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.domain_name}"
  description                       = "S3 Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
