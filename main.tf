terraform {
  backend "s3" {
    bucket         = "aleksandr-tf-state-bb13be4f" 
    key            = "dev/network/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "aleksandr-key-pro"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmsZxtcNgKzKF8b2+2masA3g1FtfSd1Q/50Qd4Qqii+qXOkPR0HK1PPES5hyM/hvtlYvtt9SwGjgKBMxbPZxLV+20SvCYXXLfWjS87b8CW7SB7oOGgfylEUq44+/dvdZ1wfoYqr63+dRvA2Fos/tIlPwNMS4WIG0DkAA54tA6/UDxzWpcRsGdkYJrWpfgboNkBXaGYJKCJ2w+SusFdRNyjHOTElOJKxdZalklmidBKzQYbAsKGlP86fMos4If+g5f9lBvW+GH9k2GiusvhKFfiXzHyysXpXuHRs0xIyV9R9F3kPPEaxl/Jbx/kuMRbv3gpz1eiygjAhRIgZJzfPdoQfXsS0KbphK7h/i7uP4Zjc5JKgXrxg4TEj9Oj+j9dHTYjsJCOZNbCNxcJ4lXKhguPO3fHlG919ZBp3TJ60zOoskyoySq2FObTCr/Pg4Tym60leSU5rmRIilZDUB2/hfRs7oG3AfQkaOiZQ2F1R8YVu5fsboGehbUrn3voB6nUQHWd71c2sxuSa0N1g9OOVtf+XwqgukfJ026ILsOk3TxSgiQ2gvLS/FkLcGDqHqC8qVy7//cV6zuPdhZaPICEGcBHzj+7MTE0igvSccizv+rswE6AdUVyVF4RUZ9zNK8Sqc2j1l6s+F7JfiOELp5lT8ZOysyn8OkR99lLfIA8+gUoXQ== test@DevSergav" # Шлях до файлу, який ми щойно створили
}

# Генерація суфікса залишається тут, бо він потрібен багатьом модулям
resource "random_id" "suffix" {
  byte_length = 4
}

# ... (твій код provider та backend залишаємо без змін) ...

# 1. Виклик модуля Storage (S3) - ЗАЛИШАЄМО АКТИВНИМ
module "storage" {
  source      = "./modules/storage"
  bucket_name = "aleksandr-web-assets-${random_id.suffix.hex}"
}

/* # 2. Виклик модуля Network (Security Group) - ЗАКОМЕНТОВАНО
module "network" {
  source  = "./modules/network"
  sg_name = "allow_web_traffic_modular"
}

# 3. Виклик модуля Compute (EC2) - ЗАКОМЕНТОВАНО
module "compute" {
  source            = "./modules/compute"
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_id = module.network.security_group_id 
  bucket_name       = module.storage.bucket_name        
  region            = var.region
  server_name       = var.server_name
}
*/

# 4. Модуль CDN (CloudFront)
module "cdn" {
  source           = "./modules/cdn"
  s3_bucket_domain = module.storage.bucket_regional_domain_name
  s3_bucket_id     = module.storage.bucket_id
}

# Додай новий output, щоб дізнатися адресу свого сайту
output "website_url" {
  value = "https://${module.cdn.cdn_domain_name}"
}
# Отримуємо результати з модулів для виводу в консоль
/*output "web_server_public_ip" {
  value = module.compute.public_dns
}

output "s3_bucket_name" {
  value = module.storage.bucket_name
}*/