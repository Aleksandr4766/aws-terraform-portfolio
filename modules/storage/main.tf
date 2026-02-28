resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

# --- НОВИЙ БЛОК: Увімкнення статичного хостингу ---
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html" # Або error.html, якщо він у тебе є
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.this.id
  # Додаємо залежність, щоб політика не створювалася раніше, ніж зніметься блок публічності
  depends_on = [aws_s3_bucket_public_access_block.this] 
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.this.arn}/*"
    }]
  })
}