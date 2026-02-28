resource "aws_cloudfront_distribution" "this" {
  origin {
    # Змінюємо домен на S3
    domain_name = var.s3_bucket_domain
    origin_id   = "S3-Origin"

    # Для S3 замість custom_origin_config зазвичай використовується S3 origin, 
    # але оскільки ми ввімкнули Static Website Hosting, залишаємо custom 
    # (це дозволить CloudFront бачити index.html автоматично)
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # S3 Website Endpoint працює по HTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin" # Має збігатися з origin_id вище

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "MyPortfolioCDN"
  }
}