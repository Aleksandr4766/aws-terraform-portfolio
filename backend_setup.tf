# 1. Бакет для зберігання файлу terraform.tfstate
resource "aws_s3_bucket" "terraform_state" {
  bucket = "aleksandr-tf-state-${random_id.suffix.hex}" # Використовуємо той самий суфікс для унікальності
  
  # Запобігаємо випадковому видаленню бакета зі стейтом
  lifecycle {
    prevent_destroy = true
  }
}

# 2. Вмикаємо версійність (щоб можна було відкотити стейт назад)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Таблиця DynamoDB для блокування (LockID - обов'язкова назва ключа)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}