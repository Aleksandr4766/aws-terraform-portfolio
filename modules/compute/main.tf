data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  # Тут ми передаємо назву бакета всередину скрипта через зміну шаблону
  user_data = templatefile("${path.module}/user_data.sh", {
    bucket_name = var.bucket_name
    region      = var.region
  })

  tags = {
    Name = var.server_name
  }
}